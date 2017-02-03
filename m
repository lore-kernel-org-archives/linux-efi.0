From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 7/7] efi: Print the secure boot status in x86 setup_arch()
 [ver #7]
Date: Fri, 3 Feb 2017 16:23:15 +0000
Message-ID: <CAKv+Gu-=-piH7FQF92T6Yn4KUHLQ-C4CtexWe8D27Tuc3h8KdA@mail.gmail.com>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587565838.4026.2835771993519594392.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com> <13280.1486138918@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <13280.1486138918@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 3 February 2017 at 16:21, David Howells <dhowells@redhat.com> wrote:
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> > +       if (IS_ENABLED(CONFIG_EFI)) {
>>
>> Shouldn't this be a runtime check?
>
> Interesting question.  The original patch I was working from had a #ifdef
> here.  Possibly it doesn't need to be there at all.  We could rely entirely on
> the value of boot_params.secure_boot.
>

Yes, but only if you are booting via UEFI, no? So perhaps use
efi_enabled(EFI_BOOT) instead?
