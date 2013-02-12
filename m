From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Date: Tue, 12 Feb 2013 15:48:02 -0800
Message-ID: <20130212154802.186ed71a.akpm@linux-foundation.org>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
	<20130207151333.f01d415c.akpm@linux-foundation.org>
	<5114CE00.6050307@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5114CE00.6050307-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Feb 2013 18:05:52 +0800
Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org> wrote:

> > I'll do this for now:
> >
> > --- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
> > +++ a/tools/testing/selftests/efivarfs/Makefile
> > @@ -6,7 +6,7 @@ test_objs = open-unlink
> >   all: $(test_objs)
> >
> >   run_tests: all
> > -	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> > +	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> >
> >   clean:
> >   	rm -f $(test_objs)
> >
> > but I'm not sure I did it right :(
> 
> efivarfs.sh requires bash currently, so we'll need to call this explicitly:
> 
> +	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> 
> Is this okay?

Judging from ./Makefile:

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

bash is "optional" (this seems dumb, because all of us have
bash and we won't test /bin/sh).

But I expect that anyone who has an interest in running the selftests
is capable of making /bin/bash appear, so I'll make that change.
