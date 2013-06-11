From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/4] efi: Convert runtime services function ptrs
Date: Tue, 11 Jun 2013 07:49:12 +0100
Message-ID: <20130611064912.GG31198@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-2-git-send-email-bp@alien8.de>
 <20130606100745.GF30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606100745.GF30420-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 06 Jun, at 11:07:45AM, Matt Fleming wrote:
> Thanks! I've chucked this into my 'urgent' queue because it's a pretty
> straight forward cleanup and there's no point in allowing it to bitrot
> any further (the change to eboot.c is already stale).

OK, I chickened out of sending this in my latest pull request after
reading Linus' -rc5 email about him not wanting to see any non-critical
changes. I've stuck it in the 'next' branch with the rest of the stuff
for v3.11.

-- 
Matt Fleming, Intel Open Source Technology Center
