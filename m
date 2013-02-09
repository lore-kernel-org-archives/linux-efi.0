From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7] efivars: New efivar_entry API
Date: Sat, 09 Feb 2013 21:12:54 +0000
Message-ID: <1360444374.7515.327.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
	 <1360357158-8168-4-git-send-email-matt@console-pimps.org>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A88489@USINDEM103.corp.hds.com>
	 <1360362300.7515.307.camel@mfleming-mobl1.ger.corp.intel.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A8853D@USINDEM103.corp.hds.com>
	 <1360364195.7515.314.camel@mfleming-mobl1.ger.corp.intel.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A885F3@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A885F3-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-02-08 at 23:22 +0000, Seiji Aguchi wrote:
> When I talked about query_variable_info() with Tony, 
> Matthew commented as follows.
> 
> http://marc.info/?l=linux-kernel&m=134305325801789&w=2
> 
> <snip>
> Running out of space in EFI isn't a well-tested scenario, and I wouldn't 
> expect all firmware to handle it gracefully. This is made worse by EFI 1 
> not providing any information about available storage.
> <snip>
> 
> I'm just concerned that set_variable() may run in the  out of space situation 
> if query_variable_info() and set_variable() are not atomic.

Hmm... OK, I see your point.

I'll add a new function that performs the query_variable_info() and
set_variable() atomically.

-- 
Matt Fleming, Intel Open Source Technology Center
