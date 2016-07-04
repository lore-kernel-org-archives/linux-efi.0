From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is
 invalid
Date: Mon, 4 Jul 2016 14:44:23 +0100
Message-ID: <20160704134423.GO8415@codeblueprint.co.uk>
References: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org>
 <20160630162751.GC29700@leverpostej>
 <CAKv+Gu_PLqOVZQC4i3v75M0a-Z9tuE86DSU4v=Vg_pBj-5Y1WQ@mail.gmail.com>
 <36dc8c28-e659-7d93-d705-ccc7734fd3d2@codeaurora.org>
 <CAKv+Gu8N3ORp_tg80wxJAgyYbNNPtfw2h-Hxy3DMkDcM6MQbAg@mail.gmail.com>
 <1b487d6d-624c-6acb-d9c1-318cd63070d5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1b487d6d-624c-6acb-d9c1-318cd63070d5-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jun, at 03:05:12PM, Jeffrey Hugo wrote:
> On 6/30/2016 12:31 PM, Ard Biesheuvel wrote:
> >
> >No, I think x86's implementation is incorrect. efi_get_memory_map()
> >should allocate some slack (i.e., the 8 entries you mentioned), and if
> >the first call to ExitBootServices() fails, we should reuse the memory
> >map buffer, and call GetMemoryMap() directly to repopulate it. Then,
> >we call ExitBootServices() once more, or give up if either call fails.
> >
> >This way, we are 100% compliant with the wording of the spec, and err
> >on the side of caution.
> >
> 
> Ok.  Let me take some time to think upon this approach and develop a working
> prototype.
 
If possible I'd much prefer to see this fixed only once in the
shared part of efi/libstub, so that the code in arch/x86 can be
deleted in favour of your more robust patch.

FYI, commit d3768d885c6c ("x86, efi: retry ExitBootServices() on
failure") illustrates that we have hit this bug in the wild on x86.
