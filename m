From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 15:42:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729223603.GC17241-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Jul 2014, Borislav Petkov wrote:

> On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
> > and it was best to keep the code simple with a KiB.
> 
> You're missing the point - the output doesn't get simple with KiB. Read
> the example I just gave you!
> 
> (13893632kiB) is actively *not* helping when one looks at it!
> 

/proc/meminfo must be frustrating then, too.

If Prarit is going to implement this suggested reverse memparse() then it 
would be nice to also have it as a generic function that others can use.
