Code.require_file "types.exs", __DIR__

defmodule Ecto.Integration.Post do
  @moduledoc """
  This module is used to test:

    * Overall functionality
    * Overall types
    * Non-null timestamps
    * Relationships

  """
  use Ecto.Model

  schema "posts" do
    field :counter, :id
    field :title, :string
    field :text, :binary
    field :temp, :string, default: "temp", virtual: true
    field :public, :boolean, default: true
    field :cost, :decimal
    field :visits, :integer
    field :intensity, :float
    field :uuid, Ecto.UUID
    has_many :comments, Ecto.Integration.Comment
    has_one :permalink, Ecto.Integration.Permalink
    has_many :comments_authors, through: [:comments, :author]
    timestamps
  end
end

defmodule Ecto.Integration.PostUsecTimestamps do
  @moduledoc """
  This module is used to test:

    * Usec timestamps

  """
  use Ecto.Model

  schema "posts" do
    field :title, :string
    timestamps usec: true
  end
end

defmodule Ecto.Integration.Comment do
  @moduledoc """
  This module is used to test:

    * Relationships

  """
  use Ecto.Model

  schema "comments" do
    field :text, :string
    field :posted, :datetime
    belongs_to :post, Ecto.Integration.Post
    belongs_to :author, Ecto.Integration.User
    has_one :post_permalink, through: [:post, :permalink]
  end
end

defmodule Ecto.Integration.Permalink do
  @moduledoc """
  This module is used to test:

    * Optimistic lock
    * Relationships

  """
  use Ecto.Model

  @foreign_key_type Custom.Permalink
  schema "permalinks" do
    field :url, :string
    field :lock_version, :integer, default: 1
    belongs_to :post, Ecto.Integration.Post
    has_many :post_comments_authors, through: [:post, :comments_authors]
  end

  optimistic_lock :lock_version
end

defmodule Ecto.Integration.User do
  @moduledoc """
  This module is used to test:

    * Timestamps
    * Relationships

  """
  use Ecto.Model

  schema "users" do
    field :name, :string
    has_many :comments, Ecto.Integration.Comment, foreign_key: :author_id
    belongs_to :custom, Ecto.Integration.Custom, references: :uuid, type: Ecto.UUID
    timestamps
  end
end

defmodule Ecto.Integration.Custom do
  @moduledoc """
  This module is used to test:

    * UUID primary key
    * Read after writes
    * Tying another schemas to an existing model

  Due to the third item, it must be a subset of posts.
  """
  use Ecto.Model

  @primary_key {:uuid, Ecto.UUID, []}
  schema "customs" do
    field :counter, :integer, read_after_writes: true
    field :visits, :integer
  end
end

defmodule Ecto.Integration.Barebone do
  @moduledoc """
  This module is used to test:

    * A model wthout primary keys

  """
  use Ecto.Model

  @primary_key false
  schema "barebones" do
    field :num, :integer
  end
end

defmodule Ecto.Integration.Tag do
  @moduledoc """
  This module is used to test:

    * The array type

  """
  use Ecto.Model

  schema "tags" do
    field :ints, {:array, :integer}
    field :uuids, {:array, Ecto.UUID}
  end
end
