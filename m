From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 07:27:50 +0000
Message-ID: <531D7786020000780012230D@nat28.tlf.novell.com>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com> <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140309185028.GB10262-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>>> On 09.03.14 at 19:50, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Sun, 09 Mar, at 04:31:41PM, Matthew Garrett wrote:
>> On Sun, Mar 09, 2014 at 04:20:20PM +0000, Matt Fleming wrote:
>> 
>> > We have tried to use the time functions before, with little success
>> > because of various bugs in the runtime implementations, e.g. see commit
>> > bacef661acdb ("x86-64/efi: Use EFI to deal with platform wall clock")
>> > and commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall
>> > clock (again)").
>> 
>> I'd naively expected that these would be more reliable after the 1:1 
>> mapping patches, so it might actually be time to give them another go.
> 
> Is there any value in that? Do machines exist where we absolutely must
> have access to the EFI time services? Either because there's no other
> method or no other working one?

Is it such a bad thing to be prepared for this sort of machine to
arrive even if likely there are none so far?

Jan
