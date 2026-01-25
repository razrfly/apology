# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Apology.Repo
alias Apology.Campaigns.{Initiative, Target, Grievance, InitiativeTarget}

# Only seed if database is empty
if Repo.aggregate(Initiative, :count) == 0 do
  IO.puts("Seeding database...")

  # Create targets (tech billionaires)
  targets_data = [
    %{
      name: "Tim Cook",
      title: "CEO",
      organization: "Apple Inc.",
      bio: "Chief Executive Officer of Apple Inc. since 2011."
    },
    %{
      name: "Jeff Bezos",
      title: "Executive Chairman",
      organization: "Amazon",
      bio: "Founder of Amazon and Blue Origin. Former CEO of Amazon."
    },
    %{
      name: "Sundar Pichai",
      title: "CEO",
      organization: "Alphabet/Google",
      bio: "Chief Executive Officer of Alphabet Inc. and Google."
    },
    %{
      name: "Satya Nadella",
      title: "CEO",
      organization: "Microsoft",
      bio: "Chief Executive Officer of Microsoft Corporation since 2014."
    },
    %{
      name: "Mark Zuckerberg",
      title: "CEO",
      organization: "Meta",
      bio: "Founder and CEO of Meta Platforms (formerly Facebook)."
    },
    %{
      name: "Elon Musk",
      title: "CEO",
      organization: "Tesla/SpaceX/X",
      bio: "CEO of Tesla, SpaceX, and owner of X (formerly Twitter)."
    },
    %{
      name: "Jensen Huang",
      title: "CEO",
      organization: "NVIDIA",
      bio: "Co-founder and CEO of NVIDIA Corporation."
    }
  ]

  targets =
    Enum.map(targets_data, fn data ->
      %Target{}
      |> Target.changeset(data)
      |> Repo.insert!()
    end)

  IO.puts("Created #{length(targets)} targets")

  # Create the main initiative
  {:ok, initiative} =
    %Initiative{}
    |> Initiative.changeset(%{
      title: "Tech Billionaires Owe America an Apology",
      tagline: "Hold tech leaders accountable for their political choices",
      description: """
      America's tech billionaires have unprecedented influence over our daily lives,
      our economy, and our democracy. When they choose to align with political figures
      who threaten democratic institutions, they owe the American people an explanation
      and an apology.

      This initiative demands accountability from tech leaders who have chosen to
      prioritize access to power over the values their companies claim to represent.
      """,
      demand_summary: """
      We demand that these tech leaders publicly acknowledge their role in normalizing
      extremism, apologize for prioritizing their business interests over democratic values,
      and commit to using their platforms and influence to strengthen, not undermine,
      American democracy.
      """,
      signature_goal: 100_000,
      status: "active",
      demand_type: "public_apology",
      visibility: "public"
    })
    |> Repo.insert()

  IO.puts("Created initiative: #{initiative.title}")

  # Link all targets to the initiative
  targets
  |> Enum.with_index()
  |> Enum.each(fn {target, index} ->
    %InitiativeTarget{}
    |> InitiativeTarget.changeset(%{
      initiative_id: initiative.id,
      target_id: target.id,
      position: index
    })
    |> Repo.insert!()
  end)

  IO.puts("Linked #{length(targets)} targets to initiative")

  # Create grievances for each target
  grievances_data = [
    # Tim Cook
    %{
      target_name: "Tim Cook",
      summary: "Attended inauguration dinner despite company's stated values on diversity",
      description: "Apple publicly champions diversity and inclusion, yet Tim Cook chose to attend events that signal support for an administration with opposing values.",
      severity: "moderate"
    },
    # Jeff Bezos
    %{
      target_name: "Jeff Bezos",
      summary: "Donated $1 million to inauguration fund",
      description: "Despite Amazon's stated commitments to progressive values, Bezos made a significant financial contribution to the inauguration.",
      severity: "severe"
    },
    # Sundar Pichai
    %{
      target_name: "Sundar Pichai",
      summary: "Remained silent while Google employees faced policy changes",
      description: "Failed to publicly advocate for workers affected by policy changes while maintaining close ties with the administration.",
      severity: "moderate"
    },
    # Satya Nadella
    %{
      target_name: "Satya Nadella",
      summary: "Prioritized government contracts over stated company values",
      description: "Microsoft pursued lucrative government contracts while avoiding public accountability for the policies those contracts support.",
      severity: "moderate"
    },
    # Mark Zuckerberg
    %{
      target_name: "Mark Zuckerberg",
      summary: "Removed content moderation policies before inauguration",
      description: "Preemptively changed Meta's content policies in what appeared to be an effort to curry favor with the incoming administration.",
      severity: "critical"
    },
    # Elon Musk
    %{
      target_name: "Elon Musk",
      summary: "Actively campaigned and donated over $100 million",
      description: "Unlike other tech leaders who merely attended events, Musk actively campaigned and became one of the largest donors.",
      severity: "critical"
    },
    # Jensen Huang
    %{
      target_name: "Jensen Huang",
      summary: "Attended inauguration while benefiting from chip policy",
      description: "NVIDIA stands to benefit significantly from administration policies while Huang publicly aligns with the administration.",
      severity: "moderate"
    }
  ]

  Enum.each(grievances_data, fn data ->
    target = Enum.find(targets, fn t -> t.name == data.target_name end)

    %Grievance{}
    |> Grievance.changeset(%{
      summary: data.summary,
      description: data.description,
      severity: data.severity,
      initiative_id: initiative.id,
      target_id: target.id
    })
    |> Repo.insert!()
  end)

  IO.puts("Created #{length(grievances_data)} grievances")
  IO.puts("Seeding complete!")
else
  IO.puts("Database already seeded, skipping...")
end
