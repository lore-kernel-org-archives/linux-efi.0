From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Date: Thu, 7 Feb 2013 15:13:33 -0800
Message-ID: <20130207151333.f01d415c.akpm@linux-foundation.org>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360162088.143076.913706486688.1.gpush@pecola>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 06 Feb 2013 22:48:08 +0800
Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org> wrote:

> This change adds a few initial efivarfs tests to the
> tools/testing/selftests directory.
> 
> The open-unlink test is based on code from
> Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
> 
> ...
>
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,4 +1,4 @@
> -TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
> +TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs

bah.  This sort of Makefile construct is a wonderful source of patch
rejects and fixups.  I'll covert this to

--- a/tools/testing/selftests/Makefile~a
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,11 @@
-TARGETS = breakpoints epoll kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
+TARGETS = breakpoints
+TARGETS += epoll
+TARGETS += kcmp
+TARGETS += mqueue
+TARGETS += vm
+TARGETS += cpu-hotplug
+TARGETS += memory-hotplug
+TARGETS += efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \

> new file mode 100644
> index 0000000..1a943ee
> --- /dev/null
> +++ b/tools/testing/selftests/efivarfs/Makefile
> @@ -0,0 +1,12 @@
> +CC = $(CROSS_COMPILE)gcc
> +CFLAGS = -Wall
> +
> +test_objs = open-unlink
> +
> +all: $(test_objs)
> +
> +run_tests: all
> +	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"

Problem.  When I apply the patch, ./efivarfs.sh doesn't have execute
permissions.  I don't think there's a way of (reliably?) transporting
this with patch and diff.

So we should explicitly invoke sh or /bin/sh or $SHELL or whatever
here.  This problem is common to several Makefiles in tools/testing/selftests/

I'll do this for now:

--- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
+++ a/tools/testing/selftests/efivarfs/Makefile
@@ -6,7 +6,7 @@ test_objs = open-unlink
 all: $(test_objs)
 
 run_tests: all
-	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
 
 clean:
 	rm -f $(test_objs)

but I'm not sure I did it right :(


The general ruleset for selftests is: do as much as you can if you're not
root and don't take too long and don't break the build on any
architecture and don't cause the top-level "make run_tests" to fail if
your feature is unconfigured.

Does this code pass all that?
