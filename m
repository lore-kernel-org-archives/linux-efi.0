From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Tue, 3 Jul 2018 09:21:30 +0200
Message-ID: <21810770-ebf2-d21e-aeef-b106849bce2f@suse.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
	<20180621162324.36656-4-ndesaulniers@google.com>
	<20180622022402.GA24194@gmail.com>
	<CAKwvOdn5gnB5cK=cy6weKyxAn4SNEdZTT_MtT_D_nHRG5EDZ4g@mail.gmail.com>
	<20180626071325.GA25751@gmail.com>
	<CAKwvOdnW9r=pgmodEL0VXCv=PZVt_WMCA+B5x4D5oKRM1y-0Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAKwvOdnW9r=pgmodEL0VXCv=PZVt_WMCA+B5x4D5oKRM1y-0Ow@mail.gmail.com>
Content-Language: de-DE
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Nick Desaulniers <ndesaulniers@google.com>, Ingo Molnar <mingo@kernel.org>
Cc: Kate Stewart <kstewart@linuxfoundation.org>, andrea.parri@amarulasolutions.com, linux-efi@vger.kernel.org, brijesh.singh@amd.com, "J. Kiszka" <jan.kiszka@siemens.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Will Deacon <will.deacon@arm.com>, jarkko.sakkinen@linux.intel.com, virtualization@lists.linux-foundation.org, Masahiro Yamada <yamada.masahiro@socionext.com>, Manoj Gupta <manojgupta@google.com>, hpa@zytor.com, boris.ostrovsky@oracle.com, Thiebaud Weksteen <tweek@google.com>, mawilcox@microsoft.com, x86@kernel.org, akataria@vmware.com, Greg Hackmann <ghackmann@google.com>, mingo@redhat.com, Alistair Strachan <astrachan@google.com>, David Rientjes <rientjes@google.com>, geert@linux-m68k.org, thomas.lendacky@amd.com, Arnd Bergmann <arnd@arndb.de>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org
List-Id: linux-efi@vger.kernel.org

On 26/06/18 18:22, Nick Desaulniers wrote:
> On Tue, Jun 26, 2018 at 3:13 AM Ingo Molnar <mingo@kernel.org> wrote:
>> Ok!
>>
>> Acked-by: Ingo Molnar <mingo@kernel.org>
>>
>> What's the planned upstreaming route for these patches/fixes?
> 
> While the fix is mainly for paravirt, 2/3 of the patches exclusively
> touch arch/x86, so I think they should go up in the x86 tree (as
> opposed to paravirt's), if you would be so kind.  hpa mentioned not
> handling merges in https://lkml.org/lkml/2018/6/14/903, so I reached
> out to you and tglx.

As there is no paravirt tree the x86 one seems to be appropriate. :-)


Juergen
