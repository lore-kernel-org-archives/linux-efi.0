From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/mm: Simplify p[g4um]d_page() macros
Date: Mon, 20 Aug 2018 14:57:39 -0700
Message-ID: <CA+55aFyo_MFz2Qg3pEbLMf3zhvAQbpZf3mQf98bTRJx28drbeQ@mail.gmail.com>
References: <20180820203705.16212-1-andi@firstfloor.org> <20180820203705.16212-2-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180820203705.16212-2-andi@firstfloor.org>
Sender: stable-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: stable <stable@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Alexander Potapenko <glider@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Brijesh Singh <brijesh.singh@amd.com>, Dave Young <dyoung@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Jonathan Corbet <corbet@lwn.net>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Larry Woodman <lwoodman@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Rik van Riel <riel@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 20, 2018 at 1:37 PM Andi Kleen <andi@firstfloor.org> wrote:
>
> From: Andi Kleen <ak@linux.intel.com>
>
> Create a pgd_pfn() macro similar to the p[4um]d_pfn() macros and then
> use the p[g4um]d_pfn() macros in the p[g4um]d_page() macros instead of
> duplicating the code.

When doing backports, _please_ explicitly specify which commit this is
upstream too.

Also, the original upstream patch is credited to Tom Lendacky.

Or is there something I'm not seeing, and this is different from
commit fd7e315988b7 ("x86/mm: Simplify p[g4um]d_page() macros")?

               Linus
