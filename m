Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E6438DC74
	for <linux-efi@vger.kernel.org>; Tue,  8 Sep 2026 07:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853105; cv=none; b=oFLDpRRXTX2bc7Yt1+b2ZncmSCrP1Nj4Jx4Vzyo0o16kyXO0XHRrcSRyOCb9bkAeYngOQw24LvCcN4S9tSu36z/K4eogzrG8RCdT4Cr7D1AK0eQSk+uUQYlc/pjZ3OHtsjYA6I/1g5Lti8+km4OWKQnbi/3kFB2/PDUFe4tx14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853105; c=relaxed/simple;
	bh=IBYPM4gS2ibae2Tkf2AXKkiQurwxQJzEd5l6rSV9/YU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=YjG359j0OdRIikWl+kgxP++AREML4CzypZdhIXtaCRZ8cy3zFs0a91ig1BWQYs/6jiFxuYkC2yv3eSGRJPtPwgunlanxqCa2vxvQHSvG9gAXMTqa3UdM52A3460i1RmOQwjByOlIYfIkp0cpGN4Kp/m1Hg0Sz8x7l3Wa38Aq6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqS2RlKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqS2RlKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB891F00A3D
	for <linux-efi@vger.kernel.org>; Tue,  8 Sep 2026 07:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853103;
	bh=/kSqH1rN9n/9GtXKzCM0V84VdAyIIJGiJDMXHLS4jlE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=kqS2RlKeEEjcRYMQLdn4gM0YZvQ+h8TrNibP1S0WQQHCAJBPvtdcafU+hURXpqV4a
	 psLrxLYyi3pxKwfoO3CUH4DSJWUd/2S0X3XMRWdeE+nRxKtCz9Ah3Ze9bmmt3RXyZI
	 TLkFB2so8HIFNSTlzlRu3w+Y1cyiEMU9rdVp4kJrsQmKmZp45znq8BYsutT9cOO2Ws
	 y1Pq7DnY9tCOKw0aStIYZXAGcqLdL/BUe9WVLGxXNpi3EgCifUp3tl38T2Rtjmqs1C
	 tDLfttwhzHHcDthlp0TVjqXHHEnsC2oQcRpTQhNvWM+w4om2Wh4y8mHCyc9+OHpGMB
	 my0wZGY23vRFg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8D11D198003A;
	Tue,  8 Sep 2026 03:38:21 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 08 Sep 2026 03:38:21 -0400
X-ME-Sender: <xms:bLufalAaQFh12jYoGOafVF2xOM0hBoJ9BWVYVI4SBJyUeoDE3qrj2g>
    <xme:bLufauXnPahEqL3YvnlhXw99v2-OlbbnkYOadFYt7NxQgPsmnu4AL2PhZS8boyFjb
    OzOElfonkzFUUctiasT8j1Bdd2k8-zYzeL6H2DTu3616IN2KgVXW9oc>
X-ME-Proxy-Cause: dmFkZTEced+ul679K3YgLYg9btfbuog+ZXQNrZVY0yYbBHzgy//3EHi4gblYcDzjPWAl0I
    QnF1ra6uZmBhvWIVd/FIGYdvsLIWziSzFvu0lQRlOO6dfq1y5cqE9ZzXugQwrS7f7ecqrc
    3HpkcNj7vMWPr5ycNKcw1FOlpuus3KCSs/tDqr3rGFFuWJpbbLoSMustknK0GUcoN4tdRD
    +P+HIKaUPTG3fjWuqQrsG/Idbforq0nj6QnKo7KVsOsKUoEudz9LPewKIZ9yvA4lvZqnyW
    a6pPecG7FvjX4OG5VdvG5Ck9YNTKT4UExvknk6lte56saC3b4uW2CILWtfkkVcjRpn0+HY
    /JSy+O2RkdSbHPPy2UcmqItFLJYn/picrW79HRV4JgtEW6tJdWb1/BWTGPyLiA8b9eQbSg
    7PGmZpRX/pD5ggaQIie0w8HrzDmyY9jLcCKEKAu6FPRU7MCChR0mZSdTuXvcatltAxnJEJ
    +PhJ3FsaWl9BlqIpBst6XTGDwyzHV3sQ7ExouR8NN77uapFPya3CMBXaqNchQ2CZQ//R3R
    QIch5VRRO20SPhRO33BFZKRpNuFwx5mEZwXmPKe5zqbazJyH6G171vPtmFmAz6ex0XhxVm
    lmY8HYF/GRWq1/Kg2FV9H1y3C1ftlXpLuqx87msdylYlqm+GUfxeACPVrb/g
X-ME-Proxy: <xmx:bbufamr4nbbgZ17QWdZyX8FzkG5shrHL1DZRrBxKt-ilmZrECQ8VVw>
    <xmx:bbufagFPwOqvqgEQbPLv9fzG7YtdOeFx4q3ffixv40gtDTcHSti91w>
    <xmx:bbufauucs_VldCCdjMoC6ItfI8XoHvb9EYGY5xXv49n9dhDC7mBpzA>
    <xmx:bbufaqXYRYr-2T2ot47Tu2hfyH6nRlIQqRt_Th0SBUqcnHFCZ_NrJg>
    <xmx:bbufaiEPkBFdf379bWI1YvSp63EQMKRzikqEmE6f57ptSbcLwjyIqsR8>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 19FD0F8007A; Tue,  8 Sep 2026 03:38:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 08 Sep 2026 09:37:59 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <33a38234-c46b-41bf-838f-db0beec8b1cf@app.fastmail.com>
In-Reply-To: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
References: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
Subject: Re: [PATCH v3] efi/libstub: add initial Boot Loader Interface support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Vincent,

On Sun, 6 Sep 2026, at 23:52, Vincent Mailhol wrote:
> The Boot Loader Interface (BLI) [1] defines EFI variables that expose
> boot loader state to the running OS. LoaderInfo identifies the boot
> loader, while LoaderDevicePartUUID records the GPT partition UUID of
> the partition containing it.
>
> LoaderDevicePartUUID is used, for example, by systemd-gpt-auto-generat=
or
> [2] to identify the disk the boot loader was launched from and
> automatically detect and mount partitions on it.
>
> GRUB [3] and systemd-boot [4] populate these variables, but when the
> kernel is started directly by EFI firmware, there is no conventional
> external boot loader to provide them. In that case, because the EFI st=
ub
> performs the boot loader role, it should provide the variables itself.
>
> Use LoaderInfo as a sentinel: if it is already set by an earlier boot
> stage or cannot be set, bail out. Otherwise, populate the other BLI
> variables.
>
> Parse the loaded image device path, extract the GUID signature from its
> GPT HD() node and publish it under the Linux loader entry vendor GUID =
as
> the volatile LoaderDevicePartUUID EFI variable.
>
> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
> path and the x86-specific x86-stub.c path.
>
> [1] The Boot Loader Interface
> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>
> [2] systemd-gpt-auto-generator
> Link:=20
> https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-au=
to-generator.html
>
> [3] GRUB -- =C2=A716.2 bli
> Link:=20
> https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule=
.html
>
> [4] systemd -- systemd-boot UEFI Boot Manager
> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=3D=
1#L102
>
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
> Changes in v3:
>
>   - Populate LoaderInfo in addition to LoaderDevicePartUUID.
>
>   - Use LoaderInfo as the provider-level sentinel before setting BLI v=
ariables.
>
>   - Drop CONFIG_EFI_STUB_BLI and enable the feature unconditionally.
>
>   - Use the libstub %pUl formatter instead of local GUID string conver=
sion.
>
>   - Mode type definitions to efi.h and add enums for the EFI HD()
>     partition format and signature type fields.
>
>   - Reintroduce the NULL check on image to resolve the sashiko finding:
>    =20
> https://sashiko.dev/#/patchset/20260903-efi_stub_bli-v2-1-dbf7ba915117=
%40kernel.org
>
> - Link to v2:=20
> https://patch.msgid.link/20260903-efi_stub_bli-v2-1-dbf7ba915117@kerne=
l.org
>
> Changes in v2:
>
>   - Add CONFIG_EFI_STUB_BLI to make the BLI feature optional.
>
>   - Use static storage for GUID initializers. This reduces the size by
>     about 10% compared to v1.
>
>   - Remove the redundant NULL check on image.
>
>   - Move the nibble-to-ASCII-hex conversion out of efi_bli_guid_to_str=
()
>     into the new efi_bli_nibble_to_hex().
>
>   - Rename variables to be closer to the EFI specification.
>
> Link to v1:=20
> https://lore.kernel.org/r/20260725-efi_stub_bli-v1-1-966e4748077f@kern=
el.org
> ---
> This patch depends on series "efi/libstub: Avoid UTF-16 conversion
> busywork" from Ard.
>
> Link:=20
> https://lore.kernel.org/all/20260906130817.1151961-9-ardb@kernel.org/
> Link:=20
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=3D=
efi-libstub-native-utf16
>
> Bloat-o-meter results on drivers/firmware/efi/libstub/lib.a before and
> after this patch on x86_64 with gcc 15.3.0:
>
>   add/remove: 4/0 grow/shrink: 1/0 up/down: 770/0 (770)
>   Function                                     old     new   delta
>   efi_bli_set_variables                          -     636    +636
>   loader_info                                    -      90     +90
>   loader_entry_guid                              -      16     +16
>   device_path_guid                               -      16     +16
>   efi_stub_entry                              4180    4192     +12
>   Total: Before=3D29436, After=3D30206, chg +2.62%
> ---
>  drivers/firmware/efi/libstub/Makefile   |  2 +-
>  drivers/firmware/efi/libstub/bli.c      | 87 ++++++++++++++++++++++++=
+++++++++
>  drivers/firmware/efi/libstub/efi-stub.c |  1 +
>  drivers/firmware/efi/libstub/efistub.h  |  2 +
>  drivers/firmware/efi/libstub/x86-stub.c |  1 +
>  include/linux/efi.h                     | 22 +++++++++
>  6 files changed, 114 insertions(+), 1 deletion(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I'll pick this up once the prerequisites are in place.
