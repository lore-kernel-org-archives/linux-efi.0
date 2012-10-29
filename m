From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 29 Oct 2012 08:49:41 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348152065-31353-1-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 20 Sep 2012, Matthew Garrett wrote:

> This is pretty much identical to the first patchset, but with the capability
> renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> to deploy these then they should disable kexec until support for signed
> kexec payloads has been merged.

Apparently your patchset currently doesn't handle device firmware loading, 
nor do you seem to mention in in the comments.

I believe signed firmware loading should be put on plate as well, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
