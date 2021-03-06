defmodule SpenderWeb.AuthControllerTest do
  use SpenderWeb.ApiCase
  import Plug.Test

  alias Spender.{Accounts.User, Repo}

  @ueberauth_auth %{credentials: %{token: "kbikn86917njbn"}, info: %{first_name: "Zacck", last_name: "Osiemo", email: "zacck@moneylog.com"}, provider: "google"}

  @error %{credentials: %{token: "" }, info: %{first_name: "Zacck", last_name: "Osiemo", email: "zacck@moneylog.com"}, provider: "google"}


  describe "AuthController" do
    test "redirects user to Google for Authentication", %{conn: conn} do
      conn = get conn, "/auth/google"
      assert redirected_to(conn, 302)
    end

    test "requires Authentication when user isnt logged in", %{conn: conn} do
      conn = get conn, "/api/another"
      assert json_response(conn, 401)
    end

    test "shows error if failure from ueberauth_auth", %{conn: conn} do
      conn = conn
      |> assign(:ueberauth_failure, %{})
      |> get("/auth/google/callback")

      assert json_response(conn, 401)
    end

    test "logs user out on logut action", %{conn: conn} do
      conn = conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/google/logout")

      assert html_response(conn, 302)
    end

    test "creates and returns user from google information",%{conn: conn} do
      #mock a response from google
      conn = conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/google/callback") #use the response

      assert json_response(conn, 200)
      user = Repo.get_by(User, email: @ueberauth_auth.info.email)
      assert Repo.aggregate(User, :count, :id) == 1
      assert user.email == @ueberauth_auth.info.email
    end

    test "errors out if error when creating user from google information", %{conn: conn} do
      conn = conn
      |> assign(:ueberauth_auth, @error)
      |> get("/auth/google/callback")
      assert json_response(conn, 422)
    end

    test "redirects user to Facebook for Authentication", %{conn: conn} do
      conn = get conn, "/auth/facebook"
      assert redirected_to(conn, 302)
    end

    test "creates and returns user from facebook information",%{conn: conn} do
      #mock a response from google
      conn = conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/facebook/callback") #use the response

      assert json_response(conn, 200)
      user = Repo.get_by(User, email: @ueberauth_auth.info.email)
      assert Repo.aggregate(User, :count, :id) == 1
      assert user.email == @ueberauth_auth.info.email
    end

    test "errors out if error when creating user from facebook information", %{conn: conn} do
      conn = conn
      |> assign(:ueberauth_auth, @error)
      |> get("/auth/facebook/callback")

      assert json_response(conn, 422)
    end

    # test "redirects user to Twitter for Authentication", %{conn: conn} do
    #   conn = conn
    #     |> init_test_session(foo: "bar")
    #     |> get("/auth/twitter")
    #   assert redirected_to(conn, 302)
    # end

    test "creates and returns user from twitter information",%{conn: conn} do
      #mock a response from google
      conn = conn
      |> init_test_session(foo: "bar")
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> fetch_session()
      |> get("/auth/twitter/callback") #use the response



      assert json_response(conn, 200)
      user = Repo.get_by(User, email: @ueberauth_auth.info.email)
      assert Repo.aggregate(User, :count, :id) == 1
      assert user.email == @ueberauth_auth.info.email
    end

    test "errors out if error when creating user from twitter information", %{conn: conn} do
      conn = conn
      |> init_test_session(foo: "bar")
      |> assign(:ueberauth_auth, @error)
      |> get("/auth/twitter/callback")
      assert json_response(conn, 422)
    end
  end

end
