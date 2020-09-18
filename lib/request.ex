defmodule Chat.Request do
  require Logger
  import Ecto.Query, only: [from: 2]



  #INSERT IF NOT EXIST

  def pick_user(name) do
    case get_user_id(name) do
      -1 -> add_user(name)
      id -> id
    end
  end

  def pick_room(name) do
    case get_room_id(name) do
      -1 -> add_room(name)
      id -> id
    end
  end

  #INSERT

  def add_user(name) do
    case Chat.Repo.insert Chat.User.changeset(%Chat.User{}, %{name: name}) do
      {:ok, user} -> user.id
      {:error, _changeset} -> -1
    end
  end

  def add_message(content, session_id) do
    user_id = get_user_id_by_session_id(session_id);
    room_id = get_room_id_by_session_id(session_id);
    case Chat.Repo.insert Chat.Message.changeset(%Chat.Message{}, %{content: content, user_id: user_id, room_id: room_id}) do
      {:ok, msg} -> msg.id
      {:error, changeset} -> Logger.error "#{inspect changeset}"
    end
  end

  def add_session(socket, user_name, room_name) do
    user_id = get_user_id(user_name);
    room_id = get_room_id(room_name);
    case Chat.Repo.insert Chat.Session.changeset(%Chat.Session{}, %{socket: Kernel.inspect(socket), user_id: user_id, room_id: room_id}) do
      {:ok, session} -> session.id
      {:error, changeset} -> Logger.error "#{inspect changeset}"
    end
  end

  def add_room(name) do
    case Chat.Repo.insert Chat.Room.changeset(%Chat.Room{}, %{name: name}) do
      {:ok, room} -> room.id
      {:error, _changeset} -> -1
    end
  end

  #SELECT

  def get_user_id(name) do
    case Chat.Repo.get_by(Chat.User, name: name) do
      nil -> -1
      user -> user.id
    end
  end

  def get_room_id(name) do
    case Chat.Repo.get_by(Chat.Room, name: name) do
      nil -> -1
      room -> room.id
    end
  end

  def get_user_id_by_session_id(session_id) do
    Chat.Repo.one(from u in Chat.User,
      join: s in Chat.Session, on: u.id == s.user_id,
      where: s.id == ^session_id,
      select: u.id)
  end

  def get_room_id_by_session_id(session_id) do
    Chat.Repo.one(from r in Chat.Room,
      join: s in Chat.Session, on: r.id == s.room_id,
      where: s.id == ^session_id,
      select: r.id)
  end

end
