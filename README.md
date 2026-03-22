# Cloud Resume ☁️

A personal resume site built and deployed entirely on AWS — inspired by the [Cloud Resume Challenge](https://cloudresumechallenge.dev/).

## 🔗 Live Site

**[jessicaparadise.com](https://jessicaparadise.com)**

## Architecture

```
GitHub Repo → GitHub Actions (CI/CD) → S3 (Static Hosting) → CloudFront (CDN) → Route 53 (DNS)
```

On every push to `main`, GitHub Actions automatically syncs the frontend to S3 and invalidates the CloudFront cache — zero manual deploys.

## AWS Services Used

| Service | Purpose |
|---------|---------|
| **S3** | Static website hosting |
| **CloudFront** | CDN for HTTPS delivery and edge caching |
| **Route 53** | Custom domain DNS management |
| **GitHub Actions** | CI/CD pipeline — auto-deploys on push to `main` |

## Project Structure

```
cloud-resume-jp/
├── .github/workflows/    # CI/CD pipeline
├── frontend/             # HTML, CSS — the resume itself
└── README.md
```

## What I Learned

- Configuring S3 bucket policies for static site hosting
- Setting up CloudFront distributions with custom SSL
- DNS management with Route 53 and domain routing
- Building a CI/CD pipeline with GitHub Actions that deploys to AWS on every commit
- The value of infrastructure automation — once the pipeline works, shipping is effortless

## About

Built by [Jessica Paradise](https://www.linkedin.com/in/jessicaparadise) as part of a hands-on cloud architecture portfolio while pursuing a BS in Computer Science at WGU and the AWS Solutions Architect Associate certification.
