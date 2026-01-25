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
    <div class="min-h-screen">
      <!-- Header -->
      <header class="py-16 px-6 lg:px-10">
        <div class="mx-auto w-full max-w-2xl md:max-w-3xl lg:max-w-5xl">
          <.link navigate="/" class="inline-flex items-center gap-2 text-sm font-medium text-olive-600 dark:text-olive-300 hover:text-olive-950 dark:hover:text-white transition mb-8">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18" />
            </svg>
            Back to initiatives
          </.link>

          <h1 class="font-display text-4xl/10 tracking-tight text-balance sm:text-5xl/12 text-olive-950 dark:text-white">
            {@initiative.title}
          </h1>
          <p :if={@initiative.tagline} class="mt-6 text-xl/8 text-olive-600 dark:text-olive-300">
            {@initiative.tagline}
          </p>
        </div>
      </header>

      <!-- Stats -->
      <section class="mx-auto w-full max-w-2xl px-6 md:max-w-3xl lg:max-w-5xl lg:px-10 mb-12">
        <div class="grid grid-cols-3 gap-4">
          <div class="rounded-2xl bg-white dark:bg-olive-900 p-6 shadow-sm ring-1 ring-olive-950/5 dark:ring-white/10 text-center">
            <div class="font-display text-3xl tracking-tight text-olive-950 dark:text-white">
              {format_number(@signature_count)}
            </div>
            <div class="mt-1 text-sm text-olive-600 dark:text-olive-300">Signatures</div>
          </div>
          <div class="rounded-2xl bg-white dark:bg-olive-900 p-6 shadow-sm ring-1 ring-olive-950/5 dark:ring-white/10 text-center">
            <div class="font-display text-3xl tracking-tight text-olive-950 dark:text-white">
              {progress_percent(@signature_count, @initiative.signature_goal)}%
            </div>
            <div class="mt-1 text-sm text-olive-600 dark:text-olive-300">of goal</div>
          </div>
          <div class="rounded-2xl bg-white dark:bg-olive-900 p-6 shadow-sm ring-1 ring-olive-950/5 dark:ring-white/10 text-center">
            <div class="font-display text-3xl tracking-tight text-olive-950 dark:text-white">
              {length(@initiative.targets)}
            </div>
            <div class="mt-1 text-sm text-olive-600 dark:text-olive-300">targets</div>
          </div>
        </div>
      </section>

      <!-- Main Content -->
      <main class="mx-auto w-full max-w-2xl px-6 md:max-w-3xl lg:max-w-5xl lg:px-10 pb-16">
        <!-- About -->
        <section class="mb-12">
          <h2 class="font-display text-2xl tracking-tight text-olive-950 dark:text-white mb-4">
            About This Initiative
          </h2>
          <div class="prose prose-olive dark:prose-invert max-w-none">
            <p class="whitespace-pre-wrap text-olive-700 dark:text-olive-200">{@initiative.description}</p>
          </div>
        </section>

        <!-- Our Demand -->
        <section :if={@initiative.demand_summary} class="mb-12">
          <h2 class="font-display text-2xl tracking-tight text-olive-950 dark:text-white mb-4">
            Our Demand
          </h2>
          <div class="rounded-2xl bg-olive-200 dark:bg-olive-800 p-8">
            <p class="whitespace-pre-wrap text-olive-800 dark:text-olive-100">{@initiative.demand_summary}</p>
          </div>
        </section>

        <!-- Targets -->
        <section class="mb-12">
          <h2 class="font-display text-2xl tracking-tight text-olive-950 dark:text-white mb-6">
            Tech Leaders Addressed
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div :for={target <- @initiative.targets} class="rounded-2xl bg-white dark:bg-olive-900 p-6 shadow-sm ring-1 ring-olive-950/5 dark:ring-white/10">
              <h3 class="font-medium text-olive-950 dark:text-white">{target.name}</h3>
              <p class="mt-1 text-sm text-olive-600 dark:text-olive-300">
                {target.title}, {target.organization}
              </p>
            </div>
          </div>
        </section>

        <!-- Grievances -->
        <section :if={length(@grievances) > 0} class="mb-12">
          <h2 class="font-display text-2xl tracking-tight text-olive-950 dark:text-white mb-6">
            Grievances
          </h2>
          <div class="space-y-4">
            <div :for={grievance <- @grievances} class="rounded-2xl bg-white dark:bg-olive-900 p-6 shadow-sm ring-1 ring-olive-950/5 dark:ring-white/10">
              <div class="flex items-start gap-4">
                <span class={"inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium #{severity_classes(grievance.severity)}"}>
                  {grievance.severity}
                </span>
                <div class="flex-1">
                  <h3 class="font-medium text-olive-950 dark:text-white">{grievance.summary}</h3>
                  <p class="mt-1 text-sm text-olive-600 dark:text-olive-300">{grievance.target.name}</p>
                  <p :if={grievance.description} class="mt-3 text-sm text-olive-700 dark:text-olive-200">
                    {grievance.description}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- CTA -->
        <section>
          <div class="rounded-2xl bg-olive-950 dark:bg-olive-800 p-8 text-center">
            <h2 class="font-display text-2xl tracking-tight text-white mb-2">
              Add Your Voice
            </h2>
            <p class="text-olive-200 mb-6">
              Join {format_number(@signature_count)} others demanding accountability
            </p>
            <button class="inline-flex items-center justify-center gap-2 rounded-full bg-white text-olive-950 px-6 py-3 text-sm font-medium hover:bg-olive-100 transition">
              Sign This Initiative
            </button>
          </div>
        </section>
      </main>
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

  defp severity_classes("critical"), do: "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
  defp severity_classes("severe"), do: "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200"
  defp severity_classes("moderate"), do: "bg-olive-200 text-olive-800 dark:bg-olive-700 dark:text-olive-200"
  defp severity_classes(_), do: "bg-olive-100 text-olive-600 dark:bg-olive-800 dark:text-olive-300"
end
