From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5 2/3] x86/asm: add _ASM_ARG* constants for argument
	registers to <asm/asm.h>
Date: Thu, 14 Jun 2018 13:47:27 -0700
Message-ID: <b027a324-ffae-fd5e-d8a3-03934be91a2d@zytor.com>
References: <20180613210518.113983-1-ndesaulniers@google.com>
	<20180613210518.113983-3-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180613210518.113983-3-ndesaulniers@google.com>
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
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de
Cc: kstewart@linuxfoundation.org, andrea.parri@amarulasolutions.com, linux-efi@vger.kernel.org, brijesh.singh@amd.com, jan.kiszka@siemens.com, will.deacon@arm.com, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, manojgupta@google.com, akataria@vmware.com, tweek@google.com, mawilcox@microsoft.com, x86@kernel.org, ghackmann@google.com, mka@chromium.org, geert@linux-m68k.org, rientjes@google.com, aryabinin@virtuozzo.com, thomas.lendacky@amd.com, arnd@arndb.de, linux-kbuild@vger.kernel.org, keescook@google.com, rostedt@goodmis.org, acme@redhat.com, caoj.fnst@cn.fujitsu.com, jpoimboe@redhat.com, sedat.dilek@gmail.com, boris.ostrovsky@oracle.com, virtualization@lists.linux-foundation.org, jgross@suse.com, michal.lkml@markovi.net, tstellar@redhat.com, gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org, astrachan@google.com, mjg59@g
List-Id: linux-efi@vger.kernel.org

On 06/13/18 14:05, Nick Desaulniers wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> i386 and x86-64 uses different registers for arguments; make them
> available so we don't have to #ifdef in the actual code.
> 
> Native size and specified size (q, l, w, b) versions are provided.
> 
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

I still object to Suggested-by: here.  Sedat did a correction, which is
a Reviewed-by:, but unless I'm completely out to sea, there was no
suggestion on Sedat's part of this; and I had certainly not seen it when
I wrote the code.

	-hpa
