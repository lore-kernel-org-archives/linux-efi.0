From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC Part1 PATCH v3 10/17] resource: Provide resource struct in
 resource walk callback
Date: Mon, 31 Jul 2017 15:19:56 -0700
Message-ID: <CAGXu5jLFxFB38oaEihy_HbjR-QKcmX2-UX1dh5OLTC3Z19qPpw@mail.gmail.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com> <20170724190757.11278-11-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-11-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>Laura Abbott <lab>
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 12:07 PM, Brijesh Singh <brijesh.singh@amd.com> wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> In prep for a new function that will need additional resource information
> during the resource walk, update the resource walk callback to pass the
> resource structure.  Since the current callback start and end arguments
> are pulled from the resource structure, the callback functions can obtain
> them from the resource structure directly.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

This is a nice clean up even without the refactoring need. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
