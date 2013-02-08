From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Date: Fri, 08 Feb 2013 18:05:52 +0800
Message-ID: <5114CE00.6050307@ozlabs.org>
References: <1360162088.142733.191120808822.0.gpush@pecola> <1360162088.143076.913706486688.1.gpush@pecola> <20130207151333.f01d415c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130207151333.f01d415c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Andrew,

Thanks for taking a look at these.

>> @@ -1,4 +1,4 @@
>> -TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
>> +TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
>
> bah.  This sort of Makefile construct is a wonderful source of patch
> rejects and fixups.  I'll covert this to
>
> --- a/tools/testing/selftests/Makefile~a
> +++ a/tools/testing/selftests/Makefile
> @@ -1,4 +1,11 @@
> -TARGETS = breakpoints epoll kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
> +TARGETS = breakpoints
> +TARGETS += epoll
> +TARGETS += kcmp
> +TARGETS += mqueue
> +TARGETS += vm
> +TARGETS += cpu-hotplug
> +TARGETS += memory-hotplug
> +TARGETS += efivarfs

Much better, thanks. I'd already had a collision with the epoll tests...

> I'll do this for now:
>
> --- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
> +++ a/tools/testing/selftests/efivarfs/Makefile
> @@ -6,7 +6,7 @@ test_objs = open-unlink
>   all: $(test_objs)
>
>   run_tests: all
> -	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> +	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
>
>   clean:
>   	rm -f $(test_objs)
>
> but I'm not sure I did it right :(

efivarfs.sh requires bash currently, so we'll need to call this explicitly:

+	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"

Is this okay?

> The general ruleset for selftests is: do as much as you can if you're not
> root and don't take too long and don't break the build on any
> architecture and don't cause the top-level "make run_tests" to fail if
> your feature is unconfigured.

Ah, good stuff to know. I'll send a patch adding this info to 
Documentation/ too.

> Does this code pass all that?

It should, yes:

  * all test requires root at present, as all efivarfs files are only
    writable by root

  * the built binaries doesn't use anything more than basic C, so should
    build fine wherever we have gcc.

  * efivarfs.sh will skip all tests if efivarfs is not mounted

However, the tests expose a bug at the moment, so run_tests will fail. 
Matt will have that fixed soon though :)

Cheers,


Jeremy
