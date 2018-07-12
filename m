From: Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Thu, 12 Jul 2018 15:22:12 -0700
Message-ID: <4bd9bee6-f2b9-3197-c205-fec104fd1090@infradead.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, catalin.marinas@arm.com, Riku Voipio <riku.voipio@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, will.deacon@arm.com, leif.lindholm@linaro.org, linux-acpi@vger.kernel.org, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On 07/04/2018 08:49 AM, Ard Biesheuvel wrote:
>   efi/libstub: taken contents of LinuxExtraArgs UEFI variable into
>     account

To me this seems an overly complicated interface to the kernel, and
still doesn't in itself solve the problem at hand -- make the
generic distro kernel with APEI support run on m400 systems.

As for me, I'd prefer something like my original patch.  It fixes
that problem, it is simple and self contained, and is very clear
in what it does.  Also, there is a limited life.  When the time
comes an announcement is made to the mailing lists 'Linux-XYZ will
no longer support the m400 Moonshot'.  Then, when the Linux-XYZ-rc1
merge window opens a patch goes in that removes the
acpi_fixup_m400_quirks() routine.

-Geoff
