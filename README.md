# Visit

**Activities first. Eating always. Sightseeing to the 9s.**

A fast, clean multi-user app for creating and sharing recommendation packs for destinations and special occasions.

---

## What it is

Visit lets anyone:

- Sign in with Apple
- Create recommendation packs for any place or occasion
- Organize places into three clear pillars
- Share a clean link with friends
- Open packs that others have shared

The included Tokyo pack is simply a high-quality **example** of content. The product is the system itself.

---

## Design

Liquid Glass aesthetic throughout — frosted materials, soft depth, continuous corners, calm hierarchy.

---

## Structure

```
Visit/
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

## Features

- Sign in with Apple (Supabase-ready)
- Create and manage packs
- Three pillars: Activities / Eating / Sightseeing
- Share codes + native share sheet
- Discover packs by code
- Example high-quality occasion pack included
- Native on both iOS and macOS

---

## Setup

1. Create a free Supabase project
2. Run `supabase/schema.sql`
3. Replace the placeholder URL and anon key in `AuthService.swift` and `PackService.swift`
4. Open in Xcode and run

---

## Philosophy

This is not a trip planner.  
It is a way to package what you actually recommend — cleanly — and give it to someone else.

Fast. Clean. Effective.
