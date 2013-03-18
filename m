From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Curious crash with secure variables
Date: Mon, 18 Mar 2013 15:02:25 +0000
Message-ID: <51472C81.5020801@console-pimps.org>
References: <1363593684.2412.5.camel@dabdike.int.hansenpartnership.com>  <1363607345.15011.339.camel@mfleming-mobl1.ger.corp.intel.com> <1363616613.2412.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363616613.2412.19.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jordan L Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 02:23 PM, James Bottomley wrote:
> Yes, it's a phenomenally complicated operation from looking at the
> TianoCore source ... might we not be better off not bothering to
> relocate and just using a private physical mapping for the calls?

Yeah, there have been various discussions about doing this. I sent some
patches last year but they broke various non-EFI machines and I haven't
had chance to pick it up again.

-- 
Matt Fleming, Intel Open Source Technology Center
