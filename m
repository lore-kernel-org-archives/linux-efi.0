Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D850AC28
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539487; cv=none; b=ej5QhaOMQc7sd9lvRgQ8gi4AW1zhS6aJ76FiL7vfmWeosSfHXUOhK0aFyANrR2hfE/QBxsy6u/tf68gGZEuDbF35c2pqeq3P+ZUIJl/Rig4XEs/4Wjg3xIhbD3+fHLlhfsyEXamnuDEUi3soH/kt7uFQFr1m8qDm2lLKuUvfv5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539487; c=relaxed/simple;
	bh=kJLKJWWt0nc7qEZWEWXx433/3B2kAD/lhNkZwiynbUM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SfkqO0iriubDPpVCo7Z/0ODSzpblDuaB6Qx/c+mHWC+VSEpAXrvu+ecGGssMYEeZLreBfF65UyhJ6PLfdZUVMRJ0HQ2k6LFtV6F6CDoJM/sZsjMw9oK8UGgEkGE3LBbCkSFkjaK1eHtwRvyrSjE65GCltTElbpCI0GUizueEklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jfou5Uxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jfou5Uxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41F61F00A3F
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539484;
	bh=0aWW926hJVH/ZOwFSJUpmN4BxO65BaD35avdvMr3hSQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Jfou5UxwPS4LU93z01wc/qzl0O+iRylhoopAR3rYWya2dSwugtHcrsU69rsc3YJAP
	 W/YnnO2NCCthVv6FRlRtrWF4SfVoPNTHQGQ+08QypQnH2QiHPZ4H+7Rf2ZBeooVcIx
	 a2vVK1b5URlmrBrOB/KRiEVT5ULDTw9/6pUiE0vtlYZeYcyOyKXpR8GvQZyRoYhsoZ
	 7otyaBAcEkzQclMBbNga0qvmOpdyCnN2Gkt3kCzskPhU0uJG7o9RuXmbA5/Dk9ba26
	 Kim+XN9VWp4qDV67YsklY6P3BzTkgQlx4IjSbfsDudFV9HPUyJOJjabAowUJlOaGgM
	 dLDibrgwPiYuQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 055F6198003A;
	Fri,  4 Sep 2026 12:31:23 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 04 Sep 2026 12:31:23 -0400
X-ME-Sender: <xms:WfKaag3V5AQvcG1mpcUW3YeBSH9qCrS0Bfg3abuIueLsp3KHgY5fyw>
    <xme:WfKaal44YzY5WqljM_fkJrFuemOJaNw-bqFEzTilHIT5ZeOJ581EsLynCWveixEjW
    ypnDZyHPALSTG488mVNZ0qf2gYN3vZCbQh-CzGu05-t-BpLKntfozQ>
X-ME-Proxy-Cause: dmFkZTGGBLagMzMIH7QIs9EGCczydtxEyv4jDoIaComNfnOlxiZqomq+gR2gIsw5Ry+bHr
    gjzV9/IZUXvlnubmWdiijerPyzLhj7lUr5hkUGE1tFcdbUIORMtAIhrMq9jySceGr+VE89
    FQqtugOSiUH6D3ou4PpylS/vHktSbye+iASmqiFl8OHi7JuL0GVeV5T6PlWMyrYvZ5IRjh
    Ja6OvXuz7VN/ii4CEFZLTrEeItTDEt5RtWSM1w3HvT+smyUn8GSJKY11/7mIkrj3WLd7wD
    S+WxQdIjKep607llb3Lt9n0UKcaOE4M53ShOYmbPsZjZ7yY50RxxVA8ITkV26tU4puYvqh
    x1l6SMD83iHRustPzvclga9jUSMmaK5S19+Ar03SsjBKndmHW0bni4ppZl7DkyZ8nDtg68
    619R8VD5hB/tYq2rOdFtORJ5CsSq+W0kN7EwsPKyzBHklQQJrtIKjzQVaebmxLup6aiQUb
    gpUnRsGcME6iYXufPFRFHf/E1pZll/MDmSdwIP+QLcO/YkXaON+eqtnUFTzFW06wcvylE6
    GtDfQMXU15qAURdhgPu388eamqZ5VPpkhoOv7pLFrG9+s89gTjkU3Qouqt9hh7pWrHSamy
    5LG5GTCq8bpdfgV3+/Dveqv2TA7lDiqgNb+s3IVrioXASTNpgI4IV5DbmWWA
X-ME-Proxy: <xmx:WvKaah9SyilSgwq9Bd28gTlpQGbkGGKbFVQT_j7O_hPRbkWWefsYfg>
    <xmx:WvKaahIfF3ar1iDi1IZEmqKeX3FKsXjxc7lbvti04JXr5gNL2LUXsg>
    <xmx:WvKaaih6RdZB1NA2S1JH17sDqST9Lq1z-TXus2g954QbkRXHAromKA>
    <xmx:WvKaap7ZYQ8muRmjRGdqARqO8-M1Vn8oBSUSjZXmDHPUVGpOQCQOpg>
    <xmx:WvKaaiYv6LqbNMYhOkBCDTMB9A4JYJWyam4ffNgzkLSNNRLiRHI1LvCl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AECA9F8007A; Fri,  4 Sep 2026 12:31:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 18:31:01 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <a3367987-7e21-42e2-853c-df64449af9a9@app.fastmail.com>
In-Reply-To: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
References: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
Subject: Re: [PATCH 0/3] efi/libstub: reduce size by optimizing GUID storage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 3 Sep 2026, at 23:25, Vincent Mailhol wrote:
> The EFI stub is size-sensitive. Several call sites currently pass GUID
> macro addresses directly, or keep GUID objects as automatic local
> variables. With gcc, this materializes the GUID at the call site,
> resulting in several assembly instructions. Using static storage instead
> emits 16 bytes of GUID data and only one instruction to pass its
> address.
>
> The first two patches convert direct GUID references and automatic GUID
> variables to static storage. The last patch factors GUID objects that
> are shared within the same translation unit.
>
> For the full series, on an x86_64 build with gcc 15.3.0, bloat-o-meter
> reports:
>
>   add/remove: 21/0 grow/shrink: 0/12 up/down: 400/-1200 (-800)
>   Function                                     old     new   delta
>   tbl_guid                                       -      32     +32
>   pci_proto                                      -      32     +32
>   guid                                           -      32     +32
>   cc_guid                                        -      32     +32
>   tpm2_guid                                      -      16     +16
>   text_to_dp_guid                                -      16     +16
>   tcg2_guid                                      -      16     +16
>   smbios_guid                                    -      16     +16
>   rng_table_guid                                 -      16     +16
>   rng_proto                                      -      16     +16
>   rng_algo_raw                                   -      16     +16
>   proto                                          -      16     +16
>   linux_eventlog_guid                            -      16     +16
>   lf2_proto_guid                                 -      16     +16
>   info_guid                                      -      16     +16
>   graphics_output_guid                           -      16     +16
>   fs_proto                                       -      16     +16
>   edid_discovered_guid                           -      16     +16
>   edid_active_guid                               -      16     +16
>   console_out_device_guid                        -      16     +16
>   apple_set_os_guid                              -      16     +16
>   efi_get_memory_map                           707     696     -11
>   efi_pci_disable_bridge_busmaster            1199    1184     -15
>   efi_get_random_bytes                         216     188     -28
>   efi_remap_image                              357     328     -29
>   efi_load_initrd                             1113    1065     -48
>   efi_get_smbios_record                        283     226     -57
>   efi_random_get_seed                         1368    1297     -71
>   efi_measure_tagged_event                     935     854     -81
>   efi_retrieve_eventlog                       1686    1570    -116
>   handle_cmdline_files                        2501    2341    -160
>   efi_stub_entry                              4180    3953    -227
>   efi_setup_graphics                          2210    1853    -357
>   Total: Before=29223, After=28423, chg -2.74%
>
> See this as my penitence for adding the BLI feature: I am giving you
> back the bytes that I consumed, and even more.
>

Thanks :-)

It would be nice if we could rely on SHF_MERGE sections here, but that
doesn't seem tractable in the context of the stub.


> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
> Vincent Mailhol (3):
>       efi/libstub: move direct GUID references to static storage
>       efi/libstub: make local GUID variables static
>       efi/libstub: factor shared static GUID variables
>

Applied to efi/next
