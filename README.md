# Visit

**Activities first. Eating always. Sightseeing to the 9s.**

A fast, clean multi-user app for creating and sharing recommendation packs for destinations and special occasions.

---

## Status

The app is **offline-ready**.  
It runs immediately with no Supabase keys, no backend, and no configuration.

Just open it and it works.

---

## What it is

Visit lets anyone:

- Create recommendation packs for any place or occasion
- Organize places into three clear pillars (Activities / Eating / Sightseeing)
- Share a clean link or text with friends
- Open packs that others have shared

The included Tokyo pack is a high-quality **example** of content. The product is the system itself.

---

## Design

Liquid Glass aesthetic — frosted materials, soft depth, continuous corners, calm hierarchy.

---

## Structure

```
Visit/
├── Package.swift
├── VisitShared/                 # Shared across iOS + macOS
│   ├── Models.swift
│   ├── Theme.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   └── PackService.swift
│   └── Views/
│       ├── RootView.swift
│       ├── MyPacksView.swift
│       ├── PackDetailView.swift
│       ├── DiscoverView.swift
│       └── ProfileView.swift
├── VisitiOS/
│   └── VisitApp.swift
├── VisitMac/
│   └── VisitApp.swift
└── supabase/
    └── schema.sql
```

---

## How to run

### Option A – Fastest (Xcode)
1. Clone the repo
2. Create a new Multiplatform App in Xcode
3. Add the `VisitShared` folder to the project
4. Set `RootView()` as the main content
5. Run on iOS Simulator or Mac

### Option B – Swift Package
```bash
git clone https://github.com/gotmyvanson62/Visit.git
cd Visit
open Package.swift
```

The app starts with a signed-in demo user and the Tokyo example pack already loaded.

---

## Later: Connect Supabase (optional)

When you want real multi-user sync:

1. Create a free Supabase project
2. Run `supabase/schema.sql`
3. Replace the placeholder logic in `AuthService` and `PackService` with the real Supabase client

Until then, everything works fully offline.

---

## Philosophy

This is not a trip planner.  
It is a way to package what you actually recommend — cleanly — and give it to someone else.

Fast. Clean. Effective.
