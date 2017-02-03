From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 7/7] efi: Print the secure boot status in x86 setup_arch() [ver #7]
Date: Fri, 03 Feb 2017 16:21:58 +0000
Message-ID: <13280.1486138918@warthog.procyon.org.uk>
References: <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com> <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk> <148587565838.4026.2835771993519594392.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com>
Content-ID: <13279.1486138918.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > +       if (IS_ENABLED(CONFIG_EFI)) {
> 
> Shouldn't this be a runtime check?

Interesting question.  The original patch I was working from had a #ifdef
here.  Possibly it doesn't need to be there at all.  We could rely entirely on
the value of boot_params.secure_boot.

David
