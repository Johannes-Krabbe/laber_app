# Tech Stack
This document describes the tech stack of [laber_app](https://github.com/johannes-krabbe/laber_app) and [laber_api](https://github.com/johannes-krabbe/laber_api) and discusses why they were chosen.

## Context
To understand the tech stack decisions, we must first understand the context in which they were made. 
This app is not meant for large-scale distribution or expected to be used by more than a couple of users once in a while for fun, but was created out of an interest to learn more about cryptography and, of course, to be used as the hand-in for my final project at my university.
The potential audience of the app is still a diverse group of friends and family with both iOS and Android phones.

## Laber App
The frontend uses Flutter with the Material UI (MUI) library.
The biggest part of the project is the code in the app. Since the app needed to be developed within a certain timeframe, but one of the desired outcomes was for it to be usable by both iOS and Android users, it was not feasible to program the app natively (e.g., in Swift or Java). Therefore, the decision was limited to a cross-platform framework. The biggest cross-platform frameworks at the current point in time are Flutter and React Native. 
The main reason why I chose Flutter over React Native was that I already had prior experience with Flutter, and it also seemed to be the more favorable framework due to its static typing and overall better developer experience, as I perceived it.
Choosing MUI was pretty easy because the looks of the app were never a priority in any way. I just needed a UI library that has all the components I could need, is easy to use, and is also somewhat good-looking. Since MUI is the default for any Flutter app, I did not put a lot of effort into deciding whether to switch and just took the simple way.

## Laber API
The backend uses TypeScript with Hono, Prisma, and PostgreSQL.
The main requirement for the backend was that it could be built up rather quickly and be a stable, well-functioning backend. I wanted to pick something I was already familiar with, and since most of my previous projects were written in TypeScript, the decision fell rather quickly to that.
My first instinct was to use Express as a backend framework since it's "battle-tested" and works reliably, but in my last projects, I preferred Hono over Express due to its easy testability and good integration with Zod for type-safe middlewares.
The backend code is designed to be easily horizontally scalable.

### Deployment
Both the backend server and the database are deployed on [fly.io](https://fly.io). For sending out SMS, the backend uses SNS by AWS. There is a deployment pipeline that automatically deploys any changes that are pushed to the main branch on GitHub.
