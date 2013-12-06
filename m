From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Date: Fri, 6 Dec 2013 14:38:27 +0100
Message-ID: <20131206133827.GB24997@rocoto.smurfnet.nu>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
 <20131205141853.GA974@darko.cambridge.arm.com>
 <1386254603.1861.120.camel@deneb.redhat.com>
 <20131205152806.GC974@darko.cambridge.arm.com>
 <20131206122511.301D6C40757@trevor.secretlab.ca>
 <1386336870.1861.155.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1386336870.1861.155.camel@deneb.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Salter <msalter@redhat.com>
Cc: "roy.franz@linaro.org" <roy.franz@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, "patches@linaro.org" <patches@linaro.org>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Dec 06, 2013 at 08:34:30AM -0500, Mark Salter wrote:
> > Or just disable runtime services on the switch to big ending. Big endian
> > should not disable the stub (but getting it to work could be a follow-up
> > patch)
> > 
> The other problem with BE is that the PE/COFF masquerading is built into
> head.S so the same Image can be used for EFI and non-EFI. I don't see
> a BE opcode which we could us to provide the magic "MZ" at the start
> of a BE kernel Image.

That's actually not an issue.
Instructions are always LE - endinaness affects only data.

/
    Leif
