From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 19 Mar 2014 18:49:49 +0100
Message-ID: <87eh1y84ea.fsf@mid.deneb.enyo.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140314231832.GA653-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org> (Theodore Ts'o's message of
	"Fri, 14 Mar 2014 19:18:32 -0400")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris@namei.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook@chromium.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module@vger.kernel.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm@linux-foundation.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa@zytor.com" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer@fedoraproject.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh@linuxfoundation.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

* Theodore Ts'o:

> Right now, even though Lenovo laptops are shipping with Windows
> 8. UEFI secure boot is not made mandatory (although it is on enough to
> brick the laptop when it runs into bugs wwith the UEFI BIOS code,
> sigh).  But sooner or later, UEFI secure boot will be on by default,
> and then if Linux distros don't have kernels where the installer can
> be run without needing to twiddle BIOS settings, it might make it
> harder for the "Year of the Desktop" to come about.

Windows 8 logo devices already enable Secure Boot by default.

One aspect which makes all this really tricky is that Microsoft is
watching what we're doing and will keep raising the bar, probably not
with the intent to lock us out completely, but sufficiently high to
make things quite annoying.  For example, any certificate-signing
certificate in the boot process needs to be an EV CA certificate,
which comes with fairly stringent requirements that are quite costly
to implement.

So any restrictions we implement as a good-will gesture will
eventually come back to haunt us.
