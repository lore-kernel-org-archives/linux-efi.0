Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7776917B505
	for <linux-efi@vger.kernel.org>; Sat,  1 Aug 2026 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589350; cv=none; b=g9iJQJPODrFO9zYGTkPqyWYs3VSkfvFt2/i4Bety8BToFL/14CYz4mHNtbRjO1h0FldhXqDM5L8askbWLc3kt1iOBkLD6SLL6Q5C0zl8MCZXtS3r2zmSmx5P0CSGgWtnJRT23/zEog0eqsbuM0Px6OnZZl3PQdEDyFXcXWJLIaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589350; c=relaxed/simple;
	bh=KpGelcy3dV6dcE5a3kY0Is5pD8kDCs10hKfBy70Nd3E=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=iTCFfSeE9DM0/LGAiGI9EFL9/RmC3e78r5ZXuXj4oKmaUBcfFhXBTukgbCubCmFItlOonhfKr+uR9eD4uq1Cut0VfOIBu7l1tBToP3W7t+9RLEcAkpmHLQs/K0GgQ2J5ei2UcLcFseqJnW+S7zmeFDQ+/cM8cpkvHonVP5qdLPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=So3IFPbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="So3IFPbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02231F00ACA;
	Sat,  1 Aug 2026 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589349;
	bh=hIghveZ5FZu3VtatR5eaqjMI1oITT5BEJT6hRgDu/bY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=So3IFPbp1JdznwQmBP+4Pn2ntp9ZKoHIc8RulXnoUMGvbi9F9OGUpcxruhsYzcFZp
	 C40EkWqkvSJL5giLOKCt0vjg/VI9+qvxfWbBXNq5IR2es0E4rojfLVvDO7uUy8i92+
	 ita5rnxjIS/GfLtWDxOyJEc0etXjiRI+WpxVtnvxliKVak5XTIpkjlqI0VVDKQy6Ap
	 H+wSdwYpyoEpmyXY/yV9CFYYnMR9G1flJEAIM5J19Euu4uZtVynfclUMYs5mmhPb+2
	 Fpv0KCrX+gwasLz8NyH4Md0dAqOP6YNQ3DnvPPPqMKPD0kUxq3u6/ZkrhLGPVdtv+t
	 PHdGSeCkFda1Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id E6684F40070;
	Sat,  1 Aug 2026 09:02:27 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Sat, 01 Aug 2026 09:02:27 -0400
X-ME-Sender: <xms:Y-5takh6VdYvXg5oxlsjk-9QJgNj8hfCppU8smEQVhrrpyryS-gzIg>
    <xme:Y-5tan2UMBSsyyx_Y6Wu3ihpKiez41Kb_Is9r-WGZ7iRBuhnPs15pAu2QTp4b0G76
    _7tu97iZdQE1OGZ7MUIX5Kcf4xTBX0Tkvt3F3qKNJKnbc-ZPN9ZMlk6>
X-ME-Proxy-Cause: dmFkZTGLKE1CXZpqSUcsmgMPFeJRWtCbkZdfvHgn+Dg73ouCGS8LvrrPqXF6rWeXl92T2u
    oAwZUiXQPLrOLuz571xjM7AJ1pAeaqKAHpl9UAlGOAOo+PMQysnwyrDjvUaI/2lgS6wAc5
    w0QvvSJDMEJFUUV9M5XsLcC/OlJpskphBNNSkv3f39K2cAySNbJ/qdi1rOhmWHxVuCTzyt
    u2A49H0VKZmpqoPZCBCHY38207vuazn3x7IwH6uBlm/KBB9G2oRiQSzl/zPDBq8dHY9aaD
    LxD74w7G6OER+NPW2HHajbnwPCvKEUaKuuKL7iyGr790XqEbockvTEpL5WhrgoDp31zjWF
    NU7hLhAAlFXVTV3SLy3BQEvtSbDHXFPjK0cxZUXdnOjwrn+Alb2He8ESyI7R+kLPwG+srl
    x9f5VmYiel/4rjM3WaFix1uLmlNwLDljfcGm0leBylSBGBN7qPprYxKj/gv+BmEA3zxZZH
    7qB8dWH+Pa4+aMahqBVK/suIPrkZbQ4vNht2U/YUp0K3wkNmXVL+SsftWgw2FOb4iUJL1n
    iQn6TrgHpF6N+OP3wvSYKbyLLMQhU7Q/9hweSqPyEH+XAqAh1xzs5yLthsD+QXXpUoyDWF
    p0ndDocg8sPEZ/dnvIn2w505NEvy8w8eI5UIby1qP3KZ3oFlUwXFLCaNK8Kg
X-ME-Proxy: <xmx:Y-5taiXntVZubJveVeRTCP8UhfxSgBtHWt9Qe2asvNRavJpTowrksA>
    <xmx:Y-5taiTqq3wzkZft35GTIlFwHylK_bvI-0a3eJlgXbuCP5sX8Zx50A>
    <xmx:Y-5tagNkguMqGi2sYqm2o9A2DHXf-vuVPh9vXJsL-V8FzXhsi0MsDw>
    <xmx:Y-5tagS3ELXQQV0RiSy5pqYNrNR2onhi-QDFVNOMeoC-rzD-Vu60oA>
    <xmx:Y-5tauhTsbJonuW1k16ZAlO4jRXcWoIUIVXTEuREsKCwfX85NQOkMV3t>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A8A2A182007E; Sat,  1 Aug 2026 09:02:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 01 Aug 2026 15:02:07 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Lukas Wunner" <lukas@wunner.de>, "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <e58a7764-c6aa-4937-a177-2f9cbbdb4bdf@app.fastmail.com>
In-Reply-To: <akufkl7EVZUa0tlY@wunner.de>
References: <20260706091813.77792-1-pengpeng@iscas.ac.cn>
 <akufkl7EVZUa0tlY@wunner.de>
Subject: Re: [PATCH] efi: apple-properties: validate setup data header length
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 6 Jul 2026, at 14:29, Lukas Wunner wrote:
> On Mon, Jul 06, 2026 at 05:18:13PM +0800, Pengpeng Hou wrote:
>> map_properties() remaps the Apple properties setup_data payload
>> and then reads the properties header fields.
>> 
>> Reject a truncated payload before checking the header version and length
>> fields.
>> 
>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
>
> Reviewed-by: Lukas Wunner <lukas@wunner.de>

Applied to efi/next - thanks.
