From: tytso@mit.edu
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 20 Mar 2014 10:55:07 -0400
Message-ID: <20140320145507.GB20618@thunk.org>
References: <1394762250.6416.24.camel@x230.lan>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Matthew Garrett <matthew.garrett@nebula.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 19, 2014 at 01:16:15PM -0700, Kees Cook wrote:
> UEFI is a red herring in both cases. This isn't about UEFI, it just
> happens that one of the things that can assert "trusted_kernel" is the
> UEFI Secure Boot path. Chrome OS would assert "trusted_kernel" by
> passing it on the kernel command line (since it, along with firmware,
> kernel, and root fs are effectively measured). A
> boot-my-router-from-CD system can assert similarly because the kernel
> is on RO media.

I disagree; it's highly likely, if not certain that Windows booting
under UEFI secure boot is going to be able to do some of the things
that people are proposing that we have to prohibit in the name of
security.  That's because presumably Windows won't be willing to make
certain usability tradeoffs, and since they control the signing certs,
even in the unlikely case that people can leverage these "holes" to
enable a boot sector virus, it seems unlikely that Windows will revoke
its own cert.

The security goals for Windows' secure boot is quite a bit weaker than
what ChromeOS is trying to promise; this is why I claim the real
argument is over what the goals are for "trusted boot".

Cheers,

					- Ted
