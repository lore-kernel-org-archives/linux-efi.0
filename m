From: Ian Campbell <ijc@debian.org>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Fri, 13 Jul 2018 11:02:39 +0100
Message-ID: <1531476159.18353.31.camel@debian.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
 <4bd9bee6-f2b9-3197-c205-fec104fd1090@infradead.org>
 <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Geoff Levand <geoff@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Riku Voipio <riku.voipio@linaro.org>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2018-07-13 at 08:15 +0200, Ard Biesheuvel wrote:
> I still think we should not be using DMI, though.

Would a quirk be acceptable if keyed on something other than DMI?

Are there some other options, perhaps some property of the ACPI tables
proper? Something which can be queried from UEFI perhaps? (I'm really
grasping at straws, but maybe someone has a smart idea).

Ian.
