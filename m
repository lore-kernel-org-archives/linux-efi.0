From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/2] x86: paravirt: make native_save_fl extern inline
Date: Tue, 5 Jun 2018 11:06:22 -0700
Message-ID: <a40b7e04-8d7c-b26f-4cb9-457bf0fd4a6a@zytor.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
	<20180605170532.170361-3-ndesaulniers@google.com>
	<26c7fd1c-ab40-368f-c2e3-43a6b45157fd@zytor.com>
	<0dd024cd-e05a-0d67-c1bf-1a532714bb1a@zytor.com>
	<CAKwvOdk0v4gY04_pbMeUT7Ly5oRHetKorQXnjp_UVBabK74Ekw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAKwvOdk0v4gY04_pbMeUT7Ly5oRHetKorQXnjp_UVBabK74Ekw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-efi@vger.kernel.org, brijesh.singh@amd.com, boris.ostrovsky@oracle.com, "J. Kiszka" <jan.kiszka@siemens.com>, Will Deacon <will.deacon@arm.com>, jarkko.sakkinen@linux.intel.com, virtualization@lists.linux-foundation.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Manoj Gupta <manojgupta@google.com>, akataria@vmware.com, Thiebaud Weksteen <tweek@google.com>, mawilcox@microsoft.com, x86@kernel.org, Greg Hackmann <ghackmann@google.com>, Matthias Kaehlcke <mka@chromium.org>, geert@linux-m68k.org, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, thomas.lendacky@amd.com, Arnd Bergmann <arnd@arndb.de>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Kees Cook <keescook@google.com>, rostedt@goodmis.org, Cao jin <caoj.fnst@cn.fujitsu.com>, Michal Marek <michal.lkml@markovi.net>, Josh Poimboeuf <jpoimboe@redhat.com>, sedat.di
List-Id: linux-efi@vger.kernel.org

On 06/05/18 10:52, Nick Desaulniers wrote:
> 
> Does the kernel have a different calling convention for 32b x86? How
> does that work? regparm=3? Does that need to be added to the
> declaration?
> 

Yes, -mregparm=3.  No, doesn't need to be added to the declaration.


>> Something like this added to <asm/asm.h> might be useful; then you can
>> simply:
>>
>>       push %_ASM_ARG1
>>
>> Version with fixed typo...
> 
> Oh, nice, thanks! I'll pick this up and add it to my patch set for v3
> (or did you want me to review/sign-off now?) I can pick up Sedat's
> suggestion.
> 

Add it to your patchset and add your own signoff underneath mine.

	-hpa
