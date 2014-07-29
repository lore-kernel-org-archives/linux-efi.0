From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 16:44:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1407291641580.961@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic> <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
 <1406675255.12100.22.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406675255.12100.22.camel@joe-AO725>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Jul 2014, Joe Perches wrote:

> Maybe yet another vsprintf extension?
> 
> Maybe %pH<vartype> where vartype is one of [hh, h, u, ul, ull]
> with something like
> 	u64 t1 = (u64)*(appropriate cast)vartype;
> 	u64 t2 = t1;
> 	int index = 0;
> 	while ((t1 >>= 10)) {
> 		index++;
> 		t2 >>= 10;
> 	}
> 	
> to output the equivalent of
> 	%llu%s, t2, "bkmgtpezy"[index]
> ala dump_pagetables
> 

Prarit has a good point about unnecessarily rounding the value, which is 
exactly what the patch is addressing, and it wouldn't be good to be 
changing the units depending on the value if anybody is using it for 
anything other than reading it with their own two eyes.  Since 
EFI_PAGE_SIZE will always be in KB, it makes sense to export it in KB.
