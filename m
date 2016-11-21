From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/9] efi: Add EFI signature data types
Date: Mon, 21 Nov 2016 16:08:05 +0000
Message-ID: <CAKv+Gu_WUG6VGEvkhDpY9nDExazhubYhvZ-j81+fbA=j5LQZJQ@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931988803.16460.18213104388363289832.stgit@warthog.procyon.org.uk>
 <alpine.OSX.2.20.1611161535590.67352@mjmartin-mac01.local> <26198.1479375840@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26198.1479375840-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 November 2016 at 09:44, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
>> The trailing ';' on EFI_CERT_X509_SHA256_GUID could trip someone up later. As
>> long as you're fixing that, the spaces before the closing parens are
>> inconsistent with the other GUID definitions in this file.
>
> Fixed, thanks.
>

With the fix

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
