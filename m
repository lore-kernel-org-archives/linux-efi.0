From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 02/17] x86/CPU/AMD: Add the Secure Encrypted
 Virtualization CPU feature
Date: Wed, 9 Aug 2017 13:17:54 -0500
Message-ID: <b2aedd44-ebbc-b196-31d0-0b423f4fa632@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-3-brijesh.singh@amd.com>
 <20170725102657.GD21822@nazgul.tnic>
 <7236d267-ebcb-8b45-b8d3-5955903e395f@amd.com>
 <20170725143615.GA26029@nazgul.tnic>
 <47ccc32e-e113-48e0-d2e0-2f23b37cc452@amd.com>
 <20170725151301.GC26029@nazgul.tnic>
 <d6fdba78-034b-d9e2-15ae-00547821a855@amd.com>
 <20170725153329.GE26029@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20170725153329.GE26029@nazgul.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Borislav Petkov <bp@suse.de>
Cc: linux-efi@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, "H . Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Piotr Luc <piotr.luc@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Airlie <airlied@redhat.com>, Laura Abbott <labbott@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Eric
List-Id: linux-efi@vger.kernel.org

On 7/25/2017 10:33 AM, Borislav Petkov wrote:
> On Tue, Jul 25, 2017 at 10:29:40AM -0500, Tom Lendacky wrote:
>> But early_identify_cpu() calls get_cpu_cap() which will check for cpuid
>> leaf 0x80000008 support and set x86_phys_bits.
> 
> Right, but it can't be less than 32, can it? And if it is more than 32
> bits, then it probably doesn't really matter on 32-bit. Unless it is
> less than 36 bits and you do PAE...
> 
>> I'll try to build and run a 32-bit kernel and see how this all flows.
> 
> Yeah, that would be good.

Ok, finally got around to running a 32-bit kernel and it reports
x86_phys_bits as 48.

Thanks,
Tom

> 
> Thanks.
> 
