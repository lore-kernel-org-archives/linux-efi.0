From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/5] efi: Move the x86 secure boot switch to generic code
Date: Wed, 24 May 2017 14:54:45 +0100
Message-ID: <23673.1495634085@warthog.procyon.org.uk>
References: <CAKv+Gu9e-r+m6TEBPOg+o01m5JmF9CYLfH4dc60a_K41zJoCKg@mail.gmail.com> <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9e-r+m6TEBPOg+o01m5JmF9CYLfH4dc60a_K41zJoCKg@mail.gmail.com>
Content-ID: <23672.1495634085.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > +         UEFI Secure Boot provides a mechanism for ensuring that the firmware
> > +         will only load signed bootloaders and kernels.  Secure boot mode may
> > +         be determined from EFI variables provided by the BIOS if not
> 
> Please replace 'the BIOS' with something more generic.

"Firmware" or "System firmware" maybe?

David
