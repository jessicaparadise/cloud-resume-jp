# Cloud Resume ☁️

A personal resume site built and deployed entirely on AWS — inspired by the [Cloud Resume Challenge](https://cloudresumechallenge.dev/).

## 🔗 Live Site

**[jessicaparadise.com](https://jessicaparadise.com)**

## Architecture

```
Site:     Route 53 (DNS) → CloudFront (CDN + HTTPS) → S3 (static hosting)
Counter:  API Gateway → Lambda → DynamoDB
Deploy:   GitHub Actions → OIDC → S3 sync + CloudFront invalidation
```

On every push to `main`, GitHub Actions signs in to AWS with OIDC, syncs the frontend to S3, and invalidates the CloudFront cache. No manual deploys, and no AWS access keys stored in GitHub.

## AWS Services Used

| Service | Purpose |
|---------|---------|
| **S3** | Static website hosting |
| **CloudFront** | CDN for HTTPS delivery and edge caching |
| **Route 53** | Custom domain DNS management |
| **API Gateway + Lambda + DynamoDB** | Live visitor counter API |
| **IAM (OIDC)** | Short-lived credentials for the pipeline, scoped to one bucket and one distribution |
| **GitHub Actions** | CI/CD pipeline — auto-deploys on push to `main` |

## Project Structure

```
cloud-resume-jp/
├── .github/workflows/    # CI/CD pipeline (GitHub OIDC, no stored keys)
├── bootstrap/            # Terraform: least-privilege deploy role
├── frontend/             # HTML, CSS — the resume itself
└── README.md
```

## What I Learned

- Configuring S3 bucket policies for static site hosting
- Setting up CloudFront distributions with custom SSL
- DNS management with Route 53 and domain routing
- Building a CI/CD pipeline with GitHub Actions that deploys to AWS on every commit
- Replacing long-lived access keys with GitHub OIDC and a least-privilege IAM role
- The value of infrastructure automation — once the pipeline works, shipping is effortless

## About

Built by [Jessica Paradise](https://www.linkedin.com/in/jessicaparadise) as part of a hands-on cloud architecture portfolio while pursuing a B.S. in Computer Science at WGU. AWS Certified Solutions Architect – Associate and Developer – Associate.
