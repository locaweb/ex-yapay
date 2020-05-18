defmodule ExYapay.Client.Request do
  @moduledoc "This module executes `HTTP Requests` to the `Yapay Intermediador API`."

  require Logger

  @behaviour ExYapay.Client

  @post_default_headers [{"Content-Type", "application/x-www-form-urlencoded"}]
  @get_default_headers [{"Content-Type", "application/json"}]
  @post_prefix Application.get_env(:ex_yapay, :request_post_prefix, "tc.")
  @get_prefix Application.get_env(:ex_yapay, :request_get_prefix, "api.")

  def post(path, body, headers \\ @post_default_headers) do
    path
    |> build_url(@post_prefix)
    |> log_request_info(body)
    |> HTTPotion.post(body: body, headers: headers, ibrowse: ibrowse_opts(), timeout: timeout())
    |> process()
  end

  def get(path, headers \\ @get_default_headers) do
    path
    |> build_url(@get_prefix)
    |> log_request_info()
    |> HTTPotion.get(ibrowse: ibrowse_opts(), headers: headers, timeout: timeout())
    |> process()
  end

  defp log_request_info(url, body \\ nil) do
    Logger.info("Processing with #{inspect(__MODULE__)}\nURL: #{url}\nBody: #{inspect(body)}")

    url
  end

  defp log_request_error(response) do
    Logger.error(
      "Error on processing with #{inspect(__MODULE__)}\nResponse: #{inspect(response)}"
    )
  end

  defp process(response) do
    case response do
      %HTTPotion.Response{status_code: 302, headers: headers} ->
        {:ok, headers.hdrs["location"]}

      %HTTPotion.Response{status_code: 200, body: body} ->
        {:ok, body |> Jason.decode(keys: :atoms) |> format_success_body()}

      %HTTPotion.Response{status_code: status, body: body} ->
        log_request_error(response)
        body = body |> Jason.decode(keys: :atoms) |> format_error_body()
        {:error, %{status: status, body: body}}

      %HTTPotion.ErrorResponse{message: message} ->
        log_request_error(response)
        {:error, %{status: nil, body: message}}
    end
  end

  defp format_success_body({:ok, %{data_response: %{transaction: transaction}}}), do: transaction
  defp format_success_body({:error, %{data: data}}), do: data

  defp format_error_body({:ok, %{error_response: %{general_errors: [%{message: message} | _]}}}),
    do: message

  defp format_error_body({:error, %{data: data}}), do: data

  defp build_url(path, prefix) do
    %{host: host, scheme: scheme, port: port} =
      :ex_yapay
      |> Application.get_env(:base_url)
      |> URI.parse()

    port = if port in [80, 443], do: "", else: ":#{port}"

    "#{scheme}://#{prefix}#{host}#{port}/#{path}"
  end

  defp ibrowse_opts, do: Application.get_env(:ex_yapay, :ibrowse_opts, [])

  defp timeout, do: Application.get_env(:ex_yapay, :timeout, 10_000)
end
