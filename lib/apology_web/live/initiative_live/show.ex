defmodule ApologyWeb.InitiativeLive.Show do
  use ApologyWeb, :live_view

  alias Apology.Campaigns

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    case Campaigns.get_initiative_by_slug(slug) do
      {:ok, initiative} ->
        signature_count = Campaigns.get_signature_count(initiative.id)
        grievances = Campaigns.list_grievances_for_initiative(initiative.id)

        {:ok,
         socket
         |> assign(:page_title, initiative.title)
         |> assign(:initiative, initiative)
         |> assign(:signature_count, signature_count)
         |> assign(:grievances, grievances)}

      {:error, :not_found} ->
        {:ok,
         socket
         |> put_flash(:error, "Initiative not found")
         |> redirect(to: "/")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8 px-4">
      <header class="mb-8">
        <h1 class="text-3xl font-bold mb-2">{@initiative.title}</h1>
        <p :if={@initiative.tagline} class="text-xl text-base-content/70">
          {@initiative.tagline}
        </p>
      </header>

      <section class="mb-8">
        <div class="stats shadow">
          <div class="stat">
            <div class="stat-title">Signatures</div>
            <div class="stat-value">{format_number(@signature_count)}</div>
            <div class="stat-desc">Goal: {format_number(@initiative.signature_goal)}</div>
          </div>
          <div class="stat">
            <div class="stat-title">Progress</div>
            <div class="stat-value">{progress_percent(@signature_count, @initiative.signature_goal)}%</div>
            <div class="stat-desc">of goal reached</div>
          </div>
          <div class="stat">
            <div class="stat-title">Targets</div>
            <div class="stat-value">{length(@initiative.targets)}</div>
            <div class="stat-desc">tech leaders</div>
          </div>
        </div>
      </section>

      <section class="mb-8">
        <h2 class="text-2xl font-semibold mb-4">About This Initiative</h2>
        <div class="prose max-w-none">
          <p class="whitespace-pre-wrap">{@initiative.description}</p>
        </div>
      </section>

      <section :if={@initiative.demand_summary} class="mb-8">
        <h2 class="text-2xl font-semibold mb-4">Our Demand</h2>
        <div class="card bg-base-200">
          <div class="card-body">
            <p class="whitespace-pre-wrap">{@initiative.demand_summary}</p>
          </div>
        </div>
      </section>

      <section class="mb-8">
        <h2 class="text-2xl font-semibold mb-4">Tech Leaders Addressed</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div :for={target <- @initiative.targets} class="card bg-base-200 shadow-sm">
            <div class="card-body">
              <h3 class="card-title">{target.name}</h3>
              <p class="text-sm text-base-content/70">
                {target.title}, {target.organization}
              </p>
            </div>
          </div>
        </div>
      </section>

      <section :if={length(@grievances) > 0} class="mb-8">
        <h2 class="text-2xl font-semibold mb-4">Grievances</h2>
        <div class="space-y-4">
          <div :for={grievance <- @grievances} class="card bg-base-200">
            <div class="card-body">
              <div class="flex items-start gap-4">
                <div class={"badge badge-#{severity_color(grievance.severity)}"}>
                  {grievance.severity}
                </div>
                <div class="flex-1">
                  <h3 class="font-semibold">{grievance.summary}</h3>
                  <p class="text-sm text-base-content/70">{grievance.target.name}</p>
                  <p :if={grievance.description} class="mt-2 text-sm">
                    {grievance.description}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="mb-8">
        <div class="card bg-primary text-primary-content">
          <div class="card-body text-center">
            <h2 class="card-title justify-center text-2xl">Add Your Voice</h2>
            <p>Join {format_number(@signature_count)} others demanding accountability</p>
            <div class="card-actions justify-center mt-4">
              <button class="btn btn-lg">Sign This Initiative</button>
            </div>
          </div>
        </div>
      </section>
    </div>
    """
  end

  defp format_number(num) when num >= 1000 do
    "#{Float.round(num / 1000, 1)}K"
  end

  defp format_number(num), do: to_string(num)

  defp progress_percent(current, goal) when goal > 0 do
    min(100, round(current / goal * 100))
  end

  defp progress_percent(_, _), do: 0

  defp severity_color("critical"), do: "error"
  defp severity_color("severe"), do: "warning"
  defp severity_color("moderate"), do: "info"
  defp severity_color(_), do: "ghost"
end
