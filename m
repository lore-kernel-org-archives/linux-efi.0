From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 20 Mar 2014 14:47:39 +0000
Message-ID: <20140320144739.14dcf53c@alan.etchedpixels.co.uk>
References: <1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
	<CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Capabilities can be seen as related to this patch set, but it cannot
> be seen as a blocker. This logic is needed today, it's implemented,
> and it clearly marks where the known problems are. If an overhaul of
> capabilities happens, it can happen separately.

A working version is needed today - but the implementation assumes things
like the idea you can blacklist a few boot parameters and all is good. The
reality is the reverse. So this at the moment is security theatre at
least for the EFI and PC case.

At the minimum you need to do module and kernel command line parameter
whitelisting/signing.

It's also rather odd to suggest the solution is to splatter changes all
over the kernel causing mass churn and maintainer headache... so that we
can do the whole mass churn again fixing what was added.

Alan
