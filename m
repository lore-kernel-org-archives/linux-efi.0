From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Subject: Re: [PATCH v10 20/38] x86, mpparse: Use memremap to map the mpf and
 mpc data
Date: Mon, 6 Nov 2017 08:13:02 +0100
Message-ID: <CAAObsKAn5JZyOQiXgJcTyeDQMBr1xCCsPMQ27J0VbdD7vy9opQ@mail.gmail.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com> <d9464b0d7c861021ed8f494e4a40d6cd10f1eddd.1500319216.git.thomas.lendacky@amd.com>
 <CAAObsKDNwxevQVjob9zNwBWR+PjL8VVvCuxRwdGmgNgZ0uhEYw@mail.gmail.com> <ea487555-0f56-d3f5-863d-7007e9631235@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <ea487555-0f56-d3f5-863d-7007e9631235@amd.com>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave
List-Id: linux-efi@vger.kernel.org

On 3 November 2017 at 16:31, Tom Lendacky <thomas.lendacky@amd.com> wrote:
> On 11/3/2017 10:12 AM, Tomeu Vizoso wrote:
>>
>> On 17 July 2017 at 23:10, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>
>>> The SMP MP-table is built by UEFI and placed in memory in a decrypted
>>> state. These tables are accessed using a mix of early_memremap(),
>>> early_memunmap(), phys_to_virt() and virt_to_phys(). Change all accesses
>>> to use early_memremap()/early_memunmap(). This allows for proper setting
>>> of the encryption mask so that the data can be successfully accessed when
>>> SME is active.
>>>
>>> Reviewed-by: Borislav Petkov <bp@suse.de>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>   arch/x86/kernel/mpparse.c | 98
>>> +++++++++++++++++++++++++++++++++--------------
>>>   1 file changed, 70 insertions(+), 28 deletions(-)
>>
>>
>> Hi there,
>>
>> today I played a bit with crosvm [0] and noticed that 4.14-rc7 doesn't
>> boot. git-bisect pointed to this patch, and reverting it indeed gets
>> things working again.
>>
>> Anybody has an idea of why this could be?
>
>
> If you send me your kernel config I'll see if I can reproduce the issue
> and debug it.

x86_64_defconfig should be enough. I have pasted my dev env
instructions here in case they help:

http://blog.tomeuvizoso.net/2017/11/experiments-with-crosvm_6.html

Thanks,

Tomeu

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
