# AI Workshop - OpenEdge ABL Project

This repository contains an OpenEdge ABL project demonstrating the Business Entity Architecture pattern for separating UI, business logic, and data access concerns.

## Project Structure

- `src/business/` - Business entity classes (CustomerEntity, EntityFactory, dataset definitions)
- `src/` - UI windows (CustomerWin.w, ItemWin.w)
- `doc/` - Architecture documentation
- `dump/` - Database schema definitions
- `.windsurf/` - AI assistant rules and workflows

## Architecture

The project demonstrates two approaches to data access:
- **Business Entity Pattern** (`CustomerWin.w`) - Uses EntityFactory, BusinessEntity classes, and datasets
- **Legacy Direct Access** (`ItemWin.w`) - Direct database access from UI (anti-pattern for refactoring)

See `doc/business-entity-pattern.md` for the full architectural documentation.

## Prerequisites

- OpenEdge 12.8+
- Sports2000 sample database
