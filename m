From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 19:03:51 -0400
Message-ID: <53D82857.4020806@redhat.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic> <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com> <20140729230102.GD17241@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729230102.GD17241-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 07/29/2014 07:01 PM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 03:42:55PM -0700, David Rientjes wrote:
>> If Prarit is going to implement this suggested reverse memparse() ...
> 
> The only meaningful argument about the formatting here IMO is what
> people staring at this output are going to understand from it.
> 
> And since those people most often tend to be the poor souls dealing with
> UEFI, we should ask them whether this needs fixing and if so, how.
> 

... I did do a get_maintainers.pl on this before sending it.  Did I miss someone
or some list? :(

P.

> That's it.
> 
