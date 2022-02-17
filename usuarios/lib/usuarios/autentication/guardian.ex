 defmodule Usuarios.Guardian do
  use Guardian, otp_app: :usuarios
  alias Usuarios.Functions
# coveralls-ignore-start
  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Functions.get_by_id!(id)
    {:ok, resource}
  end
 end
# coveralls-ignore-stop
