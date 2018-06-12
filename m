From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline
	declarations
Date: Tue, 12 Jun 2018 14:31:08 -0700
Message-ID: <7e375fab-f8ad-705a-dd04-f7e18952bd0c@zytor.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
	<20180607204927.219329-2-ndesaulniers@google.com>
	<CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
	<CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com>
	<CAKwvOdmxFHfkj81YAXa8fE86fC+k+KvqMvgk4=e62pNCcXbKOg@mail.gmail.com>
	<201806121851.w5CIpTY7134381@mail.zytor.com>
	<CAKwvOdkeEqb0HnHoggpwmHiKtDo06VN0N_r9ffv0rzigNLvXUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAKwvOdkeEqb0HnHoggpwmHiKtDo06VN0N_r9ffv0rzigNLvXUg@mail.gmail.com>
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
Cc: Kate Stewart <kstewart@linuxfoundation.org>, linux-efi@vger.kernel.org, brijesh.singh@amd.com, "J. Kiszka" <jan.kiszka@siemens.com>, Will Deacon <will.deacon@arm.com>, virtualization@lists.linux-foundation.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Manoj Gupta <manojgupta@google.com>, boris.ostrovsky@oracle.com, mawilcox@microsoft.com, x86@kernel.org, akataria@vmware.com, Greg Hackmann <ghackmann@google.com>, mingo@redhat.com, Alistair Strachan <astrachan@google.com>, David Rientjes <rientjes@google.com>, geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, acme@redhat.com, Andrey Ryabinin <aryabinin@virtuozzo.com>, sedat.dilek@gmail.com, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, tstellar@redhat.com
List-Id: linux-efi@vger.kernel.org

On 06/12/18 13:19, Nick Desaulniers wrote:
> 
> Oh, by [0] __GCC_STDC_INLINE__ is indeed actually the correct symbol
> to check for.  Clang does support that, so nothing to fix there.
> 
>> By the way, you should check clang against gcc's predefined macros by doing:
>>
>> gcc [options] -x c -Wp,-dM -E /dev/null | sort
>>
>> Options can change the predefined macros substantially, especially the, -std=, arch and -O options. -x c can be replaced with e.g. -x c++, objective-c, assembler-with-cpp etc.
> 
> Neat, I'll have to bookmark that incantation.  I can s/gcc/clang/ to
> get a similar list (which is how I know it supports
> __GCC_STDC_INLINE__).>

I bet that if you add -fgnu89-inlines then it *does* define
__GNUC_GNU_INLINE__.

> 
> Patch now becomes something like:
> 
> #ifdef __GNUC_GNU_INLINE__
> #define __gnu_inline __attribute__((gnu_inline))
> #else
> #define __gnu_inline
> #endif
> 
> #define inline inline __attribute__((always_inline, unused)) notrace
> __gnu_inline
> ...
> 
> Issues with that approach?
> 

s/__GNUC_GNU_INLINE__/__GNUC_STDC_INLINE__/

	-hpa
