From: Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Mon, 6 Aug 2018 14:23:55 -0700
Message-ID: <f7fa0a70-ee91-b228-1be1-d874826f71d1@infradead.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
 <4bd9bee6-f2b9-3197-c205-fec104fd1090@infradead.org>
 <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
 <20180713095604.GD32020@arm.com>
 <ac6bbefb-2754-4079-55a6-b9b91348a71a@infradead.org>
 <cf544006-79c6-89ba-458d-57c1718c9fa7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cf544006-79c6-89ba-458d-57c1718c9fa7@arm.com>
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
To: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Graeme Gregory <graeme.gregory@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Riku Voipio <riku.voipio@linaro.org>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

Hi All,

On 08/01/2018 03:07 AM, James Morse wrote:
> I did manage to borrow of one of these boxes to discover one additional piece of
> information: this firmware bug doesn't exist in the latest released firmware.

I went through and verified the info James provided.  The last Moonshot
Component Pack to support the m400 was 2017.06.0.  Unfortunately, the
2017.06.0 Release Notes are not available to the public, and so we
cannot check the System ROM version released.  The previous Moonshot
Component Pack, 017.04.0, from two months earlier, included System ROM
v1.01 (10/02/2015).  It seems reasonable that since there had been no
System ROM update for two years, the same System ROM v1.01 was included
in the 2017.06.0 release. 

For anyone interested, a summary of m400/Moonshot info:

Moonshot Component Pack History
	https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_2ec80e32b5d44f328d1cf9c9c7#tab-history

Moonshot Component Pack 2017.08.0 (Release Notes)
	https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-a00018563en_us
	Supersedes: MCP 2017.06.0
	Components for the cartridges listed below have been removed from this
	MCP. MCP 2017.06.0 was the last MCP to contain components for the
	following cartridges: HP ProLiant m400 Server Cartridge

Moonshot Component Pack 2017.06.0 (Announcement)
	(No public Release Notes.)
	* RECOMMENDED * Moonshot Component Pack 2017.06.0
		https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_2ec80e32b5d44f328d1cf9c9c7

Moonshot Component Pack 2017.04.0 (Release Notes)
	https://support.hpe.com/hpsc/doc/public/display?docId=c05335771
	ProLiant_m400_Server_ROM_U02_2015_10_02.HPb - System ROM for ProLiant m400 ServerCartridge 10-02-2015
	(BIOS Version: U02 v1.01 (10/02/2015))

Supported Operating Systems for Edgeline, Moonshot, and IoT GatewaySystems
	https://support.hpe.com/hpsc/doc/public/display?sp4ts.oid=null&docLocale=en_US&docId=emr_na-a00037370en_us
	ProLiant m400 Server Cartridge: Ubuntu LTS 14.04

-Geoff
