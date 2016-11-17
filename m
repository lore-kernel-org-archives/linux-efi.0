From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/9] efi: Add EFI signature data types
Date: Thu, 17 Nov 2016 09:44:00 +0000
Message-ID: <26198.1479375840@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1611161535590.67352@mjmartin-mac01.local> <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk> <147931988803.16460.18213104388363289832.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.OSX.2.20.1611161535590.67352-zaFMaa3cLiZe6KzckbbZvYT4S9po1h25@public.gmane.org>
Content-ID: <26197.1479375840.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> The trailing ';' on EFI_CERT_X509_SHA256_GUID could trip someone up later. As
> long as you're fixing that, the spaces before the closing parens are
> inconsistent with the other GUID definitions in this file.

Fixed, thanks.

David
