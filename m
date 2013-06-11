From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Tue, 11 Jun 2013 08:22:22 +0100
Message-ID: <20130611072222.GH31198@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370933558-10128-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Jun, at 07:52:38AM, Matt Fleming wrote:
> From: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>
> 
> ExitBootServices is absolutely supposed to return a failure if any
> ExitBootServices event handler changes the memory map.  Basically the
> get_map loop should run again if ExitBootServices returns an error the
> first time.  I would say it would be fair that if ExitBootServices gives
> an error the second time then Linux would be fine in returning control
> back to BIOS.
> 
> The second change is the following line:
> 
> again:
>         size += sizeof(*mem_map) * 2;
> 
> Originally you were incrementing it by the size of one memory map entry.
> The issue here is all related to the low_alloc routine you are using.
> In this routine you are making allocations to get the memory map itself.
> Doing this allocation or allocations can affect the memory map by more
> than one record.
> 
> [ mfleming - changelog, code style ]
> Signed-off-by: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

I've queued this patch up for v3.11 in my 'next' branch.

-- 
Matt Fleming, Intel Open Source Technology Center
