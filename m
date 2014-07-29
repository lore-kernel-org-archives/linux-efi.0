From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 16:07:35 -0700
Message-ID: <1406675255.12100.22.camel@joe-AO725>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	 <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com>
	 <20140729223603.GC17241@pd.tnic>
	 <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1407291541480.20991-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-07-29 at 15:42 -0700, David Rientjes wrote:
> On Wed, 30 Jul 2014, Borislav Petkov wrote:
> 
> > On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
> > > and it was best to keep the code simple with a KiB.
> > 
> > You're missing the point - the output doesn't get simple with KiB. Read
> > the example I just gave you!
> > 
> > (13893632kiB) is actively *not* helping when one looks at it!
> > 
> 
> /proc/meminfo must be frustrating then, too.
> 
> If Prarit is going to implement this suggested reverse memparse() then it 
> would be nice to also have it as a generic function that others can use.

Maybe yet another vsprintf extension?

Maybe %pH<vartype> where vartype is one of [hh, h, u, ul, ull]
with something like
	u64 t1 = (u64)*(appropriate cast)vartype;
	u64 t2 = t1;
	int index = 0;
	while ((t1 >>= 10)) {
		index++;
		t2 >>= 10;
	}
	
to output the equivalent of
	%llu%s, t2, "bkmgtpezy"[index]
ala dump_pagetables
