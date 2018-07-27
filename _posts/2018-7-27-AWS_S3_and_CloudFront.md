---
layout: post
title: Setting up an HTTPS static site using AWS S3 and Cloudfront (and also Jekyll and s3_website)
tags:
- AWS
- cloud
---

For a while now I wanted to migrate my websites away from Github pages.
While Github provides an excellent free service, there are some limitations to its capabilities, and the longer I wait the harder (or the more inconvenient) it becomes to migrate away from gh-pages.
AWS S3 + CloudFront is a widely-used alternative that has been around for a long time.
Moreover, I was planning to get more familiar with AWS at all levels anyway.
So, it's a great learning opportunity too.

There are a [number](https://medium.com/@esfoobar/setting-up-an-https-static-site-using-amazon-aws-7ab270c4e277) [of](https://www.david-merrick.com/2017/05/24/moving-my-jekyll-website-from-github-pages-to-s3/) [very](https://vickylai.com/verbose/hosting-your-static-site-with-aws-s3-route-53-and-cloudfront/) [helpful](https://medium.com/@jameshamann/migrating-your-jekyll-website-to-aws-bc9582b3fbb2) [tutorials](https://blog.jpterry.com/howto/2016/02/02/secure-static-hosting-w-s3-cloudfront-acm.html) online on how to set up an HTTPS static site using AWS S3 and CloudFront.
Of course, as always the case with blog articles, they may be outdated, incomplete, and generally not as trustworthy as [the official AWS documentation on the topic](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html), which is pretty good too; but it is also somewhat fragmented and inconvenient to follow.
So I wrote my own summary to refer to in the future.

**tldr:** Relevant AWS docs: [How to create a static website on AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html); [How to use a custom domain with AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html); [Setting up Amazon CloudFront](https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-cloudfront-walkthrough.html); [SSL certificate instructions](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html).

### 1 Set up a static site, yet without CloudFront and without HTTPS

First, we set up a static HTTP site without a custom domain on AWS S3:

- Create a bucket named `example.com` (obviously replace `example.com` with your own domain).
- Follow the procedure given at <https://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html> to *enable website hosting* for the bucket, and to make it *publicly readable*; (optionally) if you want to understand the AWS bucket access policy language see <https://docs.aws.amazon.com/AmazonS3/latest/dev//access-policy-language-overview.html>, and follow the links from there.
- Test the S3 website: Upload an `index.html` to the bucket (you can keep all options for the upload at their default values). Go to <http://example.com.s3-website-us-east-1.amazonaws.com/> (where you need to replace `example.com` with the bucket name, and `us-east-1` with your bucket's region), and see if the contents of `index.html` show up.

Yay :laughing: we have a working website!! ...without a custom domain or https :sweat_smile:

**The www subdomain:** Now prepare another S3 bucket for the subdomain "www.example.com" to be later redirected to the root domain "example.com" (btw, if you so wish, `www.example.com` can be the main S3 bucket and the `example.com` bucket can be configured to redirect &mdash; just swap their roles in this entire writeup):

- Create a bucket named `www.example.com` (all options can be left at their defaults; this bucket doesn't need to be publicly readable).
- Configure `www.example.com` to redirect all requests to `example.com` following Step 2.3 from the AWS docs at <https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html>.
- Test the endpoints for the redirect by going to <http://www.example.com.s3-website-us-east-1.amazonaws.com/> (as before replace the bucket name and region accordingly).

**Map the domain and subdomain to their S3 buckets:**

Amazon Route 53 is a service that maintains a mapping between the alias records and the IP of the bucket.
You need to follow Step 3 from the AWS docs at <https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html>.

**Configuration with your domain name registrar:**

- In AWS go to Route 53 -> Hosted zones -> example.com
- The NS (name servers) records that you see are what needs to be provided to the domain name registrar. For example, for GoDaddy I have to choose to use "custom nameservers" under the DNS settings for the domain, and then to input all (four in my case) of the URLs provided as values under the NS record.
- Your website should now appear under http://example.com (and http://www.example.com).

:smile: So we have a website with a custom domain!! ...though yet without CloudFront (so loading may be rather slow) and without HTTPS.

#### Optional: Configure an IAM role with limited access permissions

Now it seems a good idea to create a new user that has full read-write permission to the `example.com` bucket and full permission to CloudFront, but does not have any further AWS permissions.
A suitable IAM policy document can be found at: <https://github.com/laurilehmijoki/s3_website/blob/master/additional-docs/setting-up-aws-credentials.md>
Make sure to save the new user's access key ID and secret access key somewhere in a private place.

#### Optional: Use Jekyll and s3_website to generate a static site and to push it to the S3 bucket

Well, I typically use [Jekyll](https://jekyllrb.com/) to make my static sites (because it's awesome!).
The Ruby gem [`s3_website`](https://github.com/laurilehmijoki/s3_website) can be used to push the website to, or to synchronized it with the S3 bucket.
The [`s3_website` documentation](https://github.com/laurilehmijoki/s3_website) is easy to follow.
I have found it convenient to use the [`dotenv` gem](https://github.com/bkeepers/dotenv) to keep the access key ID and the secret access key of the user (that was just created) locally in a `.env` file (don't commit/push it to github!!!)
At this point you may also choose to allow `s3_website` to set up CloudFront for the website to save some time later (though without the SSL certificate, which will still have to be added manually, see below).

### 2 Request a public SSL certificate

We need an SSL certificate to enable HTTPS for the custom domain when it is accessed through CloudFront.

Follow the AWS docs at <https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html> to request an SSL certificate for your domain. Some important points:
* Add `example.com` and `*.example.com` to the certificate.
* Use DNS validation (rather than email validation), whereby in the "pending validation" stage you can choose "Create record in Route 53" which saves time (since we have already configures Route 53 for this domain).

I encountered one caveat in this process:

> To use an ACM Certificate with CloudFront, you must request or import the certificate in the US East (N. Virginia) region.

(from <http://docs.aws.amazon.com/acm/latest/userguide/acm-services.html>); i.e., change region to US East N. Virginia (top right corner within the AWS interface).

### 3 Create a CloudFront distribution

Follow these AWS docs to create a CloudFront distribution: <https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-cloudfront-walkthrough.html>; unless a CloudFront distribution was already created by `s3_website` (see one of the previous optional steps), in which case it needs to be merely edited (add the SSL certificate to it, and update "Alternate Domain Names" with `yourdomain.com` and `www.yourdomain.com` if necessary).

Notice the designated CloudFront distribution domain, which should look similar to vtrlj8ubh2k69.cloudfront.net. Once set up the website should appear under it.

**A few points I found noteworthy:**

- One can choose to set HTTP to always redirect to HTTPS.
- Once issued, the SSL certificate can be selected from the drop down menu under "Custom SSL Certificates".
- As pointed out in [Vicky Lai's blog post](https://vickylai.com/verbose/hosting-your-static-site-with-aws-s3-route-53-and-cloudfront/) the "Origin" column in the CloudFront Console should show the S3 bucket's endpoint `example.com.s3-website.us-east-1.amazonaws.com`, and not the bucket name `example.com.s3.amazonaws.com` (btw `s3_website` does this correctly). Note that when setting up, the drop down menu offers only the bucket name to be picked rather the correct endpoint; so, don't use the drop down menu; type it in yourself.[^1]

**Update A records in Route 53, and update the** `s3_website` **configs:**

- In AWS go to Route 53 -> Hosted zones -> example.com
- For both A records, change the "Alias Target" from the S3 endpoint to the CloudFront distribution domain (i.e., something like `vtrlj8ubh2k69.cloudfront.net`).
- If you use `s3_website` check or set the `cloudfront_distribution_id` property in `s3_website.yml` to the correct distribution ID (something like `SY9Q4DHIOUG7A`)

That's it &mdash; the site should now be accessible under `https://example.com` and `https://www.example.com`. :tada: :tada: :tada:

---------------------------

[^1]: It is not exactly clear to me what difference it makes to set the "Origin" to `example.com.s3.amazonaws.com` vs `example.com.s3-website.us-east-1.amazonaws.com`. However, it solved one of my issues. At first I set the "Origin" value to the bucket name, similar to `example.com.s3.amazonaws.com`, since that is what was offered by the drop down menu in CloudFront. The landing page of the website was working just fine under the custom domain. However, when I navigated to subdirectories in my domain, similar to `example.com/about/`, the server did not seem to understand that it needed to look for the `index.html` within the `about` directory, and produced an error. Once I edited the "Origin" record to the S3 bucket endpoint, similar to `example.com.s3-website.us-east-1.amazonaws.com`, all pages of the website started to display perfectly fine.

