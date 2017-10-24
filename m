From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/27] Restrict /dev/mem and /dev/kmem when the kernel is locked down
Date: Tue, 24 Oct 2017 15:56:41 +0100
Message-ID: <21927.1508857001@warthog.procyon.org.uk>
References: <CABawtvMWhHJHtog9BWNVJ3Xk-ipOhPp+TGSVNjjZD27QAfB+Nw@mail.gmail.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk> <18778.1508769258@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CABawtvMWhHJHtog9BWNVJ3Xk-ipOhPp+TGSVNjjZD27QAfB+Nw@mail.gmail.com>
Content-ID: <21926.1508857001.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: dhowells@redhat.com, joeyli <jlee@suse.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Ethan Zhao <ethan.kernel@gmail.com> wrote:

>     May I ask a question here -- Is it intentionally enabling the
> read-only mode, so userspace
> tools like dmidecode could work with kernel_is_locked_down ?  while it
> was impossible to work
> with the attached patch applied. Is it a security policy change with
> secure boot ?

I removed readability on /dev/mem, /dev/kmem and /proc/kcore so that userspace
can't use this to gain access to cryptographic material in use by the kernel.

Readability was removed on /dev/port because reading from an I/O port register
might have a side effect or might allow you to snoop h/w interactions, such as
keyboard input.

I can provide an additional config option to allow /dev/mem and similar to
remain readable - but it needs to be a temporary affair.

I can also log accesses to these interfaces so that we can find out what
breaks and fix it.

Note that dmidecode doesn't necessarily use /dev/mem:

	[root@andromeda ~]# strace -f -eopen dmidecode  >/dev/null
	open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
	open("/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
	open("/sys/firmware/dmi/tables/smbios_entry_point", O_RDONLY) = 3
	open("/sys/firmware/dmi/tables/DMI", O_RDONLY) = 3
	+++ exited with 0 +++

Indeed, my Fedora 24 test system boots without a /dev/mem file being present
(I'm not sure *why* /dev/mem isn't present, but I hadn't noticed till now).

David
