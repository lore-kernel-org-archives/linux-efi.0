From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 7/7] efi: Print the secure boot status in x86 setup_arch()
 [ver #7]
Date: Fri, 3 Feb 2017 16:29:47 +0000
Message-ID: <CAKv+Gu-O+nWmu2s8bCrANJs0JNE4QgaM=ZkSa+bu60C=-6T-Lg@mail.gmail.com>
References: <CAKv+Gu-=-piH7FQF92T6Yn4KUHLQ-C4CtexWe8D27Tuc3h8KdA@mail.gmail.com>
 <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587565838.4026.2835771993519594392.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com>
 <13280.1486138918@warthog.procyon.org.uk> <13531.1486139256@warthog.procyon.org.uk>
 <13569.1486139355@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13569.1486139355@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 3 February 2017 at 16:29, David Howells <dhowells@redhat.com> wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> > Yes, but only if you are booting via UEFI, no?
>>
>> Why limit it so?  Even if you don't boot via UEFI, the bootloader/kexec can
>> always set the secure-boot state on.
>>
>> > So perhaps use efi_enabled(EFI_BOOT) instead?
>>
>> I've no objection to that, given it incorporates a test of CONFIG_EFI.
>
> Feel free to just go ahead and change it in the patch.  We can always take the
> check out later.
>

Sure
