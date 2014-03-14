From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 21:58:54 +0000
Message-ID: <20140314215854.50ec186a@alan.etchedpixels.co.uk>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<1394825094.1286.1.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1394825094.1286.1.camel@x230>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Mar 2014 19:24:55 +0000
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Fri, 2014-03-14 at 14:11 -0400, Matthew Garrett wrote:
> 
> > The fact that you keep saying measured really does make me suspect that
> > you misunderstand the problem. There's no measurement involved, there's
> > simply an assertion that the firmware (which you're forced to trust)
> > chose, via some policy you may be unaware of, to trust the booted
> > kernel.
> 
> As an example, imagine a platform with the bootloader and kernel on
> read-only media. The platform can assert that the kernel is trusted even
> if there's no measurement of the kernel.

Only if you have a secure signed path through the controller firmware and
physical security of the hardware. If not I can reprogram your BIOS, your
GPU firmware, your USB stick or your CD-ROM controller to lie.

Anything must either be measurable or tamperproof from within the system
itself (or both). So a physically write protected ROM bootloader loading
a kernel and initrd from that same physically protected ROM is secure,
but your average CD-ROM drive is not.

Alan
